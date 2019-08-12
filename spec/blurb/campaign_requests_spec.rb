require "spec_helper"

RSpec.describe Blurb::CampaignRequests do
  before(:all) do
    blurb = Blurb.new()
    @resource = blurb.active_profile.campaigns(:sp)
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
