require "spec_helper"

RSpec.describe "Sponsored Product Keyword Requests" do
  before(:all) do
    account = Account.new(
      refresh_token: ENV["REFRESH_TOKEN"],
      region: "TEST",
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"]
    )
    @resource = account.active_profile.keywords(:sb)
    @resource_name = 'keywords'
    @create_hash = {
      keyword_text: Faker::Lorem.word,
      bid: rand(10),
      match_type: ["exact", "phrase", "broad"].sample,
      campaign_id: account.active_profile.ad_groups.list(state_filter: 'enabled').first[:campaign_id],
      ad_group_id: account.active_profile.ad_groups.list(state_filter: 'enabled').first[:ad_group_id],
    }
    @update_hash = {
      state: "enabled"
    }

    @ignored_examples = [:create, :update, :update_bulk, :delete]
  end

  # Keyword creation broken in the sandbox environment so we are unable to test these endpoints
  include_examples "request collection"
end
