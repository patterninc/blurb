require "spec_helper"

RSpec.describe CampaignRequests do
  before(:all) do
    account = Account.new(
      refresh_token: ENV["REFRESH_TOKEN"],
      region: "TEST",
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"]
    )
    @resource = account.active_profile.campaigns(:sp)
    @resource_name = 'campaign'
    @create_hash = {
      name: Faker::Lorem.word,
      state: ["enabled", "paused"].sample,
      targeting_type: ["manual", "auto"].sample,
      daily_budget: rand(10000),
      start_date: Date.today
    }
    @update_hash = {
      state: "enabled"
    }
  end

  include_examples "request collection"
end
