require "spec_helper"

RSpec.describe "Sponsored Brands Negative Keyword Requests" do
  before(:all) do
    blurb = Blurb.new()
    active_profile = blurb.active_profile
    @resource = active_profile.negative_keywords(:sb)
    @resource_name = 'keyword'
    @create_hash = {
      keyword_text: Faker::Lorem.word,
      match_type: ["exact", "phrase", "broad"].sample,
      campaign_id: active_profile.campaigns(:sb).list(state_filter: 'enabled').first&.dig(:campaign_id),
      ad_group_id: active_profile.product_ads.list(state_filter: 'enabled').first[:ad_group_id],
    }
    @update_hash = {
      match_type: ["exact", "phrase", "broad"].sample,
    }
    # TODO: Find out why create, update, update_bulk are not working
    @ignored_examples = [:delete, :create, :update, :update_bulk]
  end

  include_examples "request collection"
end
