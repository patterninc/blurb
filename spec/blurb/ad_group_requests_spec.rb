require "spec_helper"

RSpec.describe Profile do
  before(:all) do
    account = Account.new(
      refresh_token: ENV["REFRESH_TOKEN"],
      region: "TEST",
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"]
    )
    @resource = account.active_profile.ad_groups
    @resource_name = 'ad_group'
    @create_hash = {
      name: Faker::Lorem.word,
      state: ["enabled", "paused"].sample,
      default_bid: rand(100),
      campaign_id: account.active_profile.campaigns(:sp).list(state_filter: 'enabled').first[:campaign_id]
    }
    @update_hash = {
      state: "enabled"
    }
  end

  include_examples "request collection"
end
