require "spec_helper"

RSpec.describe "Campaign Negative Keyword Requests" do
  before(:all) do
    blurb = Blurb.new()
    @resource = blurb.active_profile.campaign_negative_keywords
    @resource_name = 'keyword'
    @create_hash = {
      keyword_text: Faker::Lorem.word,
      state: "enabled",
      match_type: ["negativeExact", "negativePhrase"].sample,
      campaign_id: blurb.active_profile.campaigns(:sp).list(state_filter: 'enabled').first[:campaign_id],
    }
    @update_hash = {
      state: "deleted"
    }
    @ignored_examples = [:delete]
  end

  include_examples "request collection"
end
