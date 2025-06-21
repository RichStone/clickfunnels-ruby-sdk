# frozen_string_literal: true

module CF
  module Auth
    def self.bearer_token_headers(token)
      {
        "Authorization" => "Bearer #{token}",
        "User-Agent" => "CF Ruby SDK #{CF::VERSION}"
      }
    end

    def self.validate_token!(token)
      raise CF::AuthenticationError, "API token is required" if token.nil? || token.empty?
    end
  end
end