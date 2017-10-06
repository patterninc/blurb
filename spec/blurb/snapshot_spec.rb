require "spec_helper"

RSpec.describe Blurb::Snapshot do
  include_context "shared setup"

  describe "#create" do
    context "given a keywords recordType" do
      it "returns a keywords snapshot" do
        payload_response = Blurb::Snapshot.create({
          "recordType" => Blurb::Snapshot::KEYWORDS,
          "stateFilter" => "enabled,paused,archived"
        })

        expect(payload_response).not_to be nil

        status = Blurb::Snapshot.status(payload_response["snapshotId"])

        if status && status["location"]
          report = Blurb::Snapshot.download(status["location"])
          expect(report).not_to be nil
        end
      end
    end

    context "given a campaign recordType" do
      it "returns a campaign snapshot" do
        payload_response = Blurb::Snapshot.create({
          "recordType" => Blurb::Snapshot::CAMPAIGNS,
          "stateFilter" => "enabled,paused,archived"
        })

        expect(payload_response).not_to be nil
      end
    end

    context "given a ad_group recordType" do
      it "returns a ad_group snapshot" do
        payload_response = Blurb::Snapshot.create({
          "recordType" => Blurb::Snapshot::AD_GROUPS,
          "stateFilter" => "enabled,paused,archived"
        })

        expect(payload_response).not_to be nil
      end
    end

    context "given a product_ad recordType" do
      it "returns a product_ad snapshot" do
        payload_response = Blurb::Snapshot.create({
          "recordType" => Blurb::Snapshot::PRODUCT_ADS,
          "stateFilter" => "enabled,paused,archived"
        })

        expect(payload_response).not_to be nil
      end
    end

    context "given a negativeKeywords recordType" do
      it "returns a negativeKeywords snapshot" do
        payload_response = Blurb::Snapshot.create({
          "recordType" => Blurb::Snapshot::NEGATIVE_KEYWORDS,
          "stateFilter" => "enabled,paused,archived"
        })

        expect(payload_response).not_to be nil
      end
    end

    context "given a campaignNegativeKeywords recordType" do
      it "returns a campaignNegativeKeywords snapshot" do
        payload_response = Blurb::Snapshot.create({
          "recordType" => Blurb::Snapshot::CAMPAIGN_NEGATIVE_KEYWORDS,
          "stateFilter" => "enabled,paused,archived"
        })

        expect(payload_response).not_to be nil
      end
    end
  end

end
