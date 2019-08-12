require "spec_helper"

RSpec.describe "Sponsored Brand Keyword Requests" do
  before(:all) do
    blurb = Blurb.new()
    @resource = blurb.active_profile.keywords(:sp)
    @resource_name = 'keyword'

    campaign_id = blurb.active_profile.campaigns(:sp).list(state_filter: 'enabled').first[:campaign_id]

    ad_group_id = blurb.active_profile.ad_groups.list(state_filter: 'enabled', campaign_id_filter: campaign_id).first[:ad_group_id]

    @create_hash = {
      keyword_text: Faker::Lorem.word,
      state: ["enabled", "paused"].sample,
      match_type: ["exact", "phrase", "broad"].sample,
      campaign_id: campaign_id,
      ad_group_id: ad_group_id,
    }
    @update_hash = {
      state: "enabled"
    }
  end

  # Keyword creation broken in the sandbox environment so we are unable to test these endpoints
  include_examples "request collection"
end
