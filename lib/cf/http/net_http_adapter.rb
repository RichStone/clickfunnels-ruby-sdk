# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module CF
  module HTTP
    class NetHTTPAdapter
      def initialize(options = {})
        @options = {
          timeout: 30,
          open_timeout: 10,
          use_ssl: true,
          verify_mode: OpenSSL::SSL::VERIFY_PEER
        }.merge(options)
      end

      def request(method, url, body = nil, headers = {})
        uri = URI(url)
        
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
          configure_http(http)
          
          request = build_request(method, uri, body, headers)
          response = http.request(request)
          
          handle_response(response)
        end
      end

      private

      def configure_http(http)
        http.read_timeout = @options[:timeout]
        http.open_timeout = @options[:open_timeout]
        
        if @options[:use_ssl]
          http.use_ssl = true
          http.verify_mode = @options[:verify_mode]
        end
      end

      def build_request(method, uri, body, headers)
        request_class = case method
                       when :get then Net::HTTP::Get
                       when :post then Net::HTTP::Post
                       when :put then Net::HTTP::Put # FIXME: Remove PUT.
                       when :patch then Net::HTTP::Patch
                       when :delete then Net::HTTP::Delete
                       else
                         raise ArgumentError, "Unsupported HTTP method: #{method}"
                       end

        request = request_class.new(uri)
        
        # Set headers
        headers.each { |key, value| request[key] = value }
        
        # Set body for POST/PUT/PATCH requests
        if body && [:post, :put, :patch].include?(method)
          request.body = body.is_a?(String) ? body : JSON.generate(body)
          request["Content-Type"] = "application/json" unless request["Content-Type"]
        end
        
        request
      end

      def handle_response(response)
        {
          status: response.code.to_i,
          headers: response.to_hash,
          body: response.body
        }
      end
    end
  end
end