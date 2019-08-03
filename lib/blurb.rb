require "blurb/account"
require "blurb/client"

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
