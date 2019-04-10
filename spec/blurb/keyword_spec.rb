require "spec_helper"

RSpec.describe Blurb::Keyword do
  include_context "shared setup"

  describe "keyword crud operations" do
    # TODO: The create keyword endpoint is broken on the Amazon Advertising API.  Since I'm unable to create a keyword in the sandbox, I can't test any of the other functions.  We should add testing at a later date once this endpoint is fixed.
    
    # it "creates and retrieves and deletes a keyword" do
    #   ad_group = @ad_group_instance.list(Blurb::AdGroup::SPONSORED_PRODUCTS).first
    #
    #   keyword = @keyword_instance.create("sp", {
    #     "campaignId" => ad_group['campaignId'],
    #     "adGroupId" => ad_group['adGroupId'],
    #     "keywordText" => "keyword",
    #     "state" => "enabled",
    #     "matchType" => "exact"
    #   })
    #   expect(keyword.first["code"]).to eq "SUCCESS"
    #
    #   delete = @keyword_instance.delete(keyword.first["keywordId"])
    #   expect(delete["code"]).to eq "SUCCESS"
    # end
    #
    # it "retrieves a list of keywords" do
    #   list = @keyword_instance.list(Blurb::Keyword::SPONSORED_PRODUCTS)
    #   puts "---------------#{list}"
    #   extended_list = @keyword_instance.list_extended(Blurb::Keyword::SPONSORED_PRODUCTS)
    #   expect(list.length).to be > 1
    #   expect(extended_list.length).to be > 1
    #   expect(extended_list.first["servingStatus"]).to_not be nil
    # end
    #
    # it "retrieves a single keyword" do
    #   id = @keyword_instance.list(Blurb::Keyword::SPONSORED_PRODUCTS).first["keywordId"]
    #   keyword = @keyword_instance.retrieve(id, Blurb::Keyword::SPONSORED_PRODUCTS)
    #   extended_keyword = @keyword_instance.retrieve_extended(id, Blurb::Keyword::SPONSORED_PRODUCTS)
    #   expect(keyword["keywordId"]).to eq id
    #   expect(extended_keyword["keywordId"]).to eq id
    #   expect(extended_keyword["servingStatus"]).to_not be nil
    # end
  end

end
