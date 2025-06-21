# frozen_string_literal: true

require "json"
require "cgi"

module CF
  class Client
    def initialize(configuration)
      @configuration = configuration
      @http_client = CF::HTTP::Client.new
    end

    def get(path, params = {})
      request(:get, path, nil, params)
    end

    def post(path, body = nil, params = {})
      request(:post, path, body, params)
    end

    def put(path, body = nil, params = {})
      request(:put, path, body, params)
    end

    def patch(path, body = nil, params = {})
      request(:patch, path, body, params)
    end

    def delete(path, params = {})
      request(:delete, path, nil, params)
    end

    private

    attr_reader :configuration, :http_client

    def request(method, path, body = nil, params = {})
      validate_configuration!
      
      url = build_url(path, params)
      headers = build_headers
      
      log_request(method, url, body, headers) if configuration.log_requests?
      
      case method
      when :get, :delete
        response = http_client.send(method, url, headers)
      else
        response = http_client.send(method, url, body, headers)
      end
      
      log_response(response) if configuration.log_requests?
      
      handle_response(response)
    rescue => e
      log_error(e) if configuration.log_requests?
      raise
    end

    def validate_configuration!
      CF::Auth.validate_token!(configuration.api_token)
      raise CF::ConfigurationError, "Configuration is invalid" unless configuration.valid?
    end

    def build_url(path, params = {})
      url = "#{configuration.base_url}#{path}"
      return url if params.empty?
      
      query_string = build_query_string(params)
      "#{url}?#{query_string}"
    end

    def build_headers
      headers = CF::Auth.bearer_token_headers(configuration.api_token)
      headers["Accept"] = "application/json"
      headers["Content-Type"] = "application/json"
      headers
    end

    def build_query_string(params)
      params.map do |key, value|
        if value.is_a?(Array)
          value.map { |v| "#{key}[]=#{CGI.escape(v.to_s)}" }.join("&")
        elsif value.is_a?(Hash)
          value.map { |k, v| "#{key}[#{k}]=#{CGI.escape(v.to_s)}" }.join("&")
        else
          "#{key}=#{CGI.escape(value.to_s)}"
        end
      end.join("&")
    end

    def handle_response(response)
      case response[:status]
      when 200..299
        parse_response_body(response[:body])
      when 400
        create_error_response("Bad Request", CF::BadRequestError, response)
      when 401
        create_error_response("Unauthorized", CF::UnauthorizedError, response)
      when 403
        create_error_response("Forbidden", CF::ForbiddenError, response)
      when 404
        create_error_response("Not Found", CF::NotFoundError, response)
      when 422
        create_error_response("Unprocessable Entity", CF::UnprocessableEntityError, response)
      when 429
        create_error_response("Too Many Requests", CF::TooManyRequestsError, response)
      when 500
        create_error_response("Internal Server Error", CF::InternalServerError, response)
      when 502
        create_error_response("Bad Gateway", CF::BadGatewayError, response)
      when 503
        create_error_response("Service Unavailable", CF::ServiceUnavailableError, response)
      when 504
        create_error_response("Gateway Timeout", CF::GatewayTimeoutError, response)
      else
        create_error_response("HTTP #{response[:status]}", CF::APIError, response)
      end
    end

    def parse_response_body(body)
      return nil if body.nil? || body.empty?
      
      JSON.parse(body, symbolize_names: true)
    rescue JSON::ParserError
      body
    end

    def create_error_response(message, error_class, response)
      {
        error: true,
        error_type: error_class.name,
        message: message,
        status: response[:status],
        response_body: response[:body],
        # response_headers: response[:headers]
      }
    end

    def log_request(method, url, body, headers)
      return unless configuration.logger
      
      configuration.logger.info("[CF SDK] Request: #{method.upcase} #{url}")
      # configuration.logger.debug("[CF SDK] Headers: #{headers.inspect}")
      configuration.logger.debug("[CF SDK] Body: #{body}") if body
    end

    def log_response(response)
      return unless configuration.logger
      
      configuration.logger.info("[CF SDK] Response: #{response[:status]}")
      # configuration.logger.debug("[CF SDK] Response Headers: #{response[:headers]}")
      configuration.logger.debug("[CF SDK] Response Body: #{response[:body]}")
    end

    def log_error(error)
      return unless configuration.logger
      
      configuration.logger.error("[CF SDK] Error: #{error.class.name} - #{error.message}")
    end
  end
end