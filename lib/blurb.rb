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
require "blurb/keyword"
require "blurb/ad_group"
require "blurb/account"
require "blurb/client"

# class Blurb
#   def initialize(
#     client_id:,
#     client_secret:,
#   )
#
#   end
# end

module Blurb

  def self.default_account
    {
      client_secret: self.client_secret,
      client_id: self.client_id,
      refresh_token: self.refresh_token,
      profile_id: self.profile_id,
      region: self.region
    }
  end

  class << self
    attr_accessor :client_secret, :client_id, :refresh_token, :profile_id, :region
  end

end
