# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "cf"

require "minitest/autorun"
require "minitest/reporters"
require "webmock/minitest"

unless ENV['RM_INFO']
  Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
end

class Minitest::Test
  def setup
    CF.reset!
    WebMock.reset!
    WebMock.disable_net_connect!
  end

  def teardown
    CF.reset!
    WebMock.reset!
  end

  private

  def configure_cf
    CF.configure do |config|
      config.subdomain = "test"
      config.api_token = "test_token"
      config.debug = false
    end
  end

  def stub_request_with_response(method, path, response_body = {}, status = 200)
    url = "https://test.myclickfunnels.com/api/v2#{path}"
    
    stub_request(method, url)
      .with(
        headers: {
          "Authorization" => "Bearer test_token",
          "Accept" => "application/json",
          "Content-Type" => "application/json",
          "User-Agent" => "CF Ruby SDK #{CF::VERSION}"
        }
      )
      .to_return(
        status: status,
        body: response_body.is_a?(String) ? response_body : JSON.generate(response_body),
        headers: { "Content-Type" => "application/json" }
      )
  end
end