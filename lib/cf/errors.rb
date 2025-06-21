# frozen_string_literal: true

module CF
  class Error < StandardError; end
  
  class ConfigurationError < Error; end
  
  class AuthenticationError < Error; end
  
  class APIError < Error
    attr_reader :status, :response_body, :response_headers

    def initialize(message, status: nil, response_body: nil, response_headers: nil)
      super(message)
      @status = status
      @response_body = response_body
      @response_headers = response_headers
    end
  end

  class BadRequestError < APIError; end
  class UnauthorizedError < APIError; end
  class ForbiddenError < APIError; end
  class NotFoundError < APIError; end
  class UnprocessableEntityError < APIError; end
  class TooManyRequestsError < APIError; end
  class InternalServerError < APIError; end
  class BadGatewayError < APIError; end
  class ServiceUnavailableError < APIError; end
  class GatewayTimeoutError < APIError; end
end