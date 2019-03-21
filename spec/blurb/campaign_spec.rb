require "spec_helper"

RSpec.describe Blurb::Campaign do
  include_context "shared setup"

  describe "campaign crud operations" do
    it "creates and retrieves and deletes a campaign" do
      campaign = @campaign_instance.create("sp", {
        "name" => "My Test Campaign",
        "campaignType" => "sponsoredProducts",
        "state" => "enabled",
        "dailyBudget" => 10,
        "startDate" => (Time.now).strftime('%Y%m%d'),
        "targetingType" => "abc"
      })
      expect(campaign.first["code"]).to eq "SUCCESS"

      delete = @campaign_instance.delete(campaign.first["campaignId"])
      expect(delete["code"]).to eq "SUCCESS"
    end

    it "retrieves a list of campaigns" do
      list = @campaign_instance.list(Blurb::Campaign::SPONSORED_PRODUCTS)
      extended_list = @campaign_instance.list_extended(Blurb::Campaign::SPONSORED_PRODUCTS)
      expect(list.length).to be > 1
      expect(extended_list.length).to be > 1
      expect(extended_list.first["servingStatus"]).to_not be nil
    end

    it "retrieves a single campaign" do
      id = @campaign_instance.list(Blurb::Campaign::SPONSORED_PRODUCTS).first["campaignId"]
      campaign = @campaign_instance.retrieve(id, Blurb::Campaign::SPONSORED_PRODUCTS)
      extended_campaign = @campaign_instance.retrieve_extended(id, Blurb::Campaign::SPONSORED_PRODUCTS)
      expect(campaign["campaignId"]).to eq id
      expect(extended_campaign["campaignId"]).to eq id
      expect(extended_campaign["servingStatus"]).to_not be nil
    end
  end

end
