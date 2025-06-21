# frozen_string_literal: true

module CF
  class Configuration
    attr_accessor :subdomain, :api_token, :api_version, :debug, :timeout, :workspace_id, :team_id

    def initialize
      @subdomain = nil
      @api_token = nil
      @api_version = "v2"
      @debug = false
      @timeout = 30
      @logger = nil
      @workspace_id = nil
      @team_id = nil
    end

    def base_url
      raise CF::ConfigurationError, "Subdomain is required" unless subdomain
      
      "https://#{subdomain}.myclickfunnels.com/api/#{api_version}"
    end

    def valid?
      !subdomain.nil? && !api_token.nil?
    end

    def debug?
      debug
    end

    def log_requests?
      debug?
    end

    def logger
      @logger ||= debug? ? CF::FileLogger.new : nil
    end

    def logger=(custom_logger)
      @logger = custom_logger
    end
  end
end