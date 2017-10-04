require "spec_helper"

RSpec.describe Blurb::BidRecommendation do
  include_context "shared setup"

  describe "#keyword_recommendations" do
    context "given a keywordId" do
      it "returns recommendations" do
        Blurb.test_env = false
        payload_response = Blurb::BidRecommendation.keyword_recommendations({
          "keywordId" => "65925711506995"
        })

        # expect(payload_response).not_to be nil
      end
    end
  end

end
