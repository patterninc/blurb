require "spec_helper"

RSpec.describe Blurb::SuggestedKeyword do
  include_context "shared setup"

  describe "#asin_suggestions" do
    context "given an asin" do
      it "returns suggestions" do
        payload_response = @suggested_keyword_instance.asin_suggestions({
          "asinValue" => "B0006HUJJO"
        })

        expect(payload_response).not_to be nil
      end
    end
  end

  describe "#bulk_asin_suggestions" do
    context "given a list of asins" do
      it "returns suggestions" do
        payload_response = @suggested_keyword_instance.bulk_asin_suggestions({
          "asins" => ["B0006HUJJO","B0042SWOHI"]
        })

        expect(payload_response).not_to be nil
      end
    end
  end

  describe "#ad_group_suggestions" do
    context "given an adGroupId" do
      it "returns suggestions" do
        payload_response = @suggested_keyword_instance.ad_group_suggestions({
          "adGroupId" => "A03102093TZ1MBBGK086X"
        })

        # expect(payload_response).not_to be nil
      end
    end
  end
end
