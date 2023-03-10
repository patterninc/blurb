require "blurb/account"
require "blurb/client"

class Blurb
  attr_accessor :client, :account

  delegate :reports_api_version, to: :client

  def initialize(
    reports_api_version: 2,
    # Default to env variables
    client_id: ENV["BLURB_CLIENT_ID"],
    client_secret: ENV["BLURB_CLIENT_SECRET"],
    refresh_token: ENV["BLURB_REFRESH_TOKEN"],
    region: ENV["BLURB_REGION"],
    profile_id: ENV["BLURB_PROFILE_ID"] # profile_id can be left nil
  )
    @client = Client.new(client_id: client_id, client_secret: client_secret, reports_api_version: reports_api_version)
    @account = Account.new(refresh_token: refresh_token, region: region, client: @client, profile_id: profile_id)
  end

  def profiles
    @account.profiles
  end

  def active_profile
    @account.active_profile
  end
end
