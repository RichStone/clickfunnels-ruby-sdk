# frozen_string_literal: true

module CF
  module HTTP
    class Client
      def initialize(adapter = nil)
        @adapter = adapter || NetHTTPAdapter.new
      end

      def get(url, headers = {})
        @adapter.request(:get, url, nil, headers)
      end

      def post(url, body = nil, headers = {})
        @adapter.request(:post, url, body, headers)
      end

      def put(url, body = nil, headers = {})
        @adapter.request(:put, url, body, headers)
      end

      def patch(url, body = nil, headers = {})
        @adapter.request(:patch, url, body, headers)
      end

      def delete(url, headers = {})
        @adapter.request(:delete, url, nil, headers)
      end

      private

      attr_reader :adapter
    end
  end
end