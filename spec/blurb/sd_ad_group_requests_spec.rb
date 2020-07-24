require "spec_helper"

RSpec.describe "SD Ad Group Requests" do
  before(:all) do
    blurb = Blurb.new()
    @resource = blurb.active_profile.sd_ad_groups
    @resource_name = 'ad_group'
    @create_hash = {
      name: Faker::Lorem.word + rand(100).to_s,
      state: ["enabled", "paused"].sample,
      default_bid: rand(5),
      campaign_id: blurb.active_profile.campaigns(:sd).list(state_filter: 'enabled').first[:campaign_id]
    }
    @update_hash = {
      state: "enabled"
    }
  end

  include_examples "request collection"
end
