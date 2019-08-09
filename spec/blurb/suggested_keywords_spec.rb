require "spec_helper"

RSpec.describe Blurb::SuggestedKeywordRequests do
  before(:all) do
    @blurb = Blurb.new()
    @resource = @blurb.active_profile.suggested_keywords
    @ad_group_id = @blurb.active_profile.ad_groups.list.last[:ad_group_id]
    @asin = "B00KTNSRKI"
  end

  describe "#ad_group_retrieve" do
    it "requests suggested keywords for specified ad group" do
      @response = @resource.ad_group_retrieve(@ad_group_id)
      expect(@response[:suggested_keywords]).to be_truthy
      expect(@response[:suggested_keywords].length).to be > 0
    end
  end

  describe "#ad_group_retrieve_extended" do
    it "requests extended suggested keywords for specified ad group" do
      @response = @resource.ad_group_retrieve_extended(@ad_group_id)
      expect(@response).to be_truthy
      expect(@response.length).to be > 0
    end
  end

  describe "#asin_retrieve" do
    it "provides suggested keywords for specified ASIN" do
      @response = @resource.asin_retrieve(@asin)
      expect(@response).to be_truthy
      expect(@response.length).to be > 0
    end
  end

  describe "#asin_list" do
    it "provides suggested keywords for specified list of ASINs"
  end
end