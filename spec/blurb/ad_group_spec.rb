require "spec_helper"

RSpec.describe Blurb::AdGroup do
  include_context "shared setup"

  describe "adGroup crud operations" do
    it "creates and retrieves and deletes a adGroup" do
      campaign = @campaign_instance.list(Blurb::AdGroup::SPONSORED_PRODUCTS).first
      adGroup = @ad_group_instance.create("sp", {
        "name" => "my test ad group",
        "campaignId" => campaign['campaignId'],
        "defaultBid" => 0.10,
        "state" => "enabled",
      })
      expect(adGroup.first["code"]).to eq "SUCCESS"

      delete = @ad_group_instance.delete(adGroup.first["adGroupId"])
      expect(delete["code"]).to eq "SUCCESS"
    end

    it "retrieves a list of adGroups" do
      list = @ad_group_instance.list(Blurb::AdGroup::SPONSORED_PRODUCTS)
      extended_list = @ad_group_instance.list_extended(Blurb::AdGroup::SPONSORED_PRODUCTS)
      expect(list.length).to be > 1
      expect(extended_list.length).to be > 1
      expect(extended_list.first["servingStatus"]).to_not be nil
    end

    it "retrieves a single adGroup" do
      id = @ad_group_instance.list(Blurb::AdGroup::SPONSORED_PRODUCTS).first["adGroupId"]
      adGroup = @ad_group_instance.retrieve(id, Blurb::AdGroup::SPONSORED_PRODUCTS)
      extended_adGroup = @ad_group_instance.retrieve_extended(id, Blurb::AdGroup::SPONSORED_PRODUCTS)
      expect(adGroup["adGroupId"]).to eq id
      expect(extended_adGroup["adGroupId"]).to eq id
      expect(extended_adGroup["servingStatus"]).to_not be nil
    end
  end

end
