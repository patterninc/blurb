require "oauth2"
require "rest-client"

require "blurb/version"
require "blurb/base_resource"

require "blurb/bid_recommendation"
require "blurb/campaign"
require "blurb/profile"
require "blurb/report"
require "blurb/snapshot"
require "blurb/suggested_keyword"

module Blurb

  def self.default_account
    {
      client_secret: self.client_secret,
      client_id: self.client_id,
      refresh_token: self.refresh_token,
      profile_id: self.profile_id,
      eu_env: self.eu_env
    }
  end

  class << self
    attr_accessor :client_secret, :client_id, :refresh_token, :profile_id, :test_env, :eu_env
  end

end
