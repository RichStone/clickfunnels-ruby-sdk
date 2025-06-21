# frozen_string_literal: true

require_relative "cf/version"
require_relative "cf/configuration"
require_relative "cf/client"
require_relative "cf/errors"
require_relative "cf/auth"
require_relative "cf/logger"
require_relative "cf/http/client"
require_relative "cf/http/net_http_adapter"
require_relative "cf/resources/base"

module CF
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def client
      @client ||= Client.new(configuration)
    end

    def reset!
      @configuration = nil
      @client = nil
    end
  end
end