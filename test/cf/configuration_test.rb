# frozen_string_literal: true

require "test_helper"

class CF::ConfigurationTest < Minitest::Test
  def setup
    @config = CF::Configuration.new
  end

  def test_default_values
    assert_nil @config.subdomain
    assert_nil @config.api_token
    assert_equal "v2", @config.api_version
    assert_equal false, @config.debug
    assert_equal 30, @config.timeout
  end

  def test_base_url_with_subdomain
    @config.subdomain = "test"
    assert_equal "https://test.myclickfunnels.com/api/v2", @config.base_url
  end

  def test_base_url_without_subdomain
    assert_raises CF::ConfigurationError do
      @config.base_url
    end
  end

  def test_valid_configuration
    @config.subdomain = "test"
    @config.api_token = "token"
    assert @config.valid?
  end

  def test_invalid_configuration
    refute @config.valid?
    
    @config.subdomain = "test"
    refute @config.valid?
    
    @config.api_token = "token"
    assert @config.valid?
  end

  def test_debug_mode
    refute @config.debug?
    
    @config.debug = true
    assert @config.debug?
  end
end