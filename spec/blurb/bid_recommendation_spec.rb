require "spec_helper"

RSpec.describe Blurb::BidRecommendation do
  include_context "shared setup"

  describe "#keyword_recommendations" do
    context "given a keywordId" do
      it "returns recommendations" do
        @bid_recommendation_instance.test_env = false
        payload_response = @bid_recommendation_instance.keyword_recommendations({
          "keywordId" => "65925711506995"
        })

        # expect(payload_response).not_to be nil
      end
    end
  end

end
