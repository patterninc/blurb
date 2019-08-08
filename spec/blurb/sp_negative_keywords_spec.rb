require "spec_helper"

RSpec.describe "Ad Group Negative Keyword Requests" do
  before(:all) do
    blurb = Blurb.new()
    @resource = blurb.active_profile.negative_keywords(:sp)
    @resource_name = 'keyword'
    @create_hash = {
      keyword_text: Faker::Lorem.word,
      state: ["enabled", "archived"].sample,
      match_type: ["negativeExact", "negativePhrase"].sample,
      campaign_id: blurb.active_profile.campaigns(:sp).list(state_filter: 'enabled').first[:campaign_id],
      ad_group_id: blurb.active_profile.product_ads.list(state_filter: 'enabled').first[:ad_group_id],
    }
    @update_hash = {
      state: "enabled"
    }
  end

  include_examples "request collection"
end
