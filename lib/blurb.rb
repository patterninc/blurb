require "oauth2"
require "rest-client"

require "blurb/version"
require "blurb/base_resource"

require "blurb/bid_recommendation"
require "blurb/profile"
require "blurb/report"
require "blurb/snapshot"
require "blurb/suggested_keyword"
require "blurb/token"

module Blurb
  TOKEN_URL = "https://api.amazon.com"
  API_URL = "https://advertising-api.amazon.com"
  TEST_API_URL = "https://advertising-api-test.amazon.com"

  def self.client
    return OAuth2::Client.new(
      "",
      "",
      :site => TOKEN_URL
    )
  end

  # By default this gem will use the production API url unless the test_env module
  # variable is set to true. Then the test API url will be used
  def self.active_api_url
    if test_env
      return TEST_API_URL
    end

    return API_URL
  end

  class << self
    attr_accessor :client_secret, :client_id, :refresh_token, :profile_id, :test_env
  end

end
