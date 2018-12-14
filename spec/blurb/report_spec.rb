require "spec_helper"

RSpec.describe Blurb::Report do
  include_context "shared setup"

  describe "#create" do
    context "given a keywords recordType" do
      Blurb.test_env = false

      it "returns a keywords report" do
        payload_response = Blurb::Report.create({
          "recordType" => Blurb::Report::KEYWORDS,
          "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          "metrics" => "impressions,clicks",
          "segment" => "query"
        })

        expect(payload_response).not_to be nil

        status = Blurb::Report.status(payload_response["reportId"])

        if status && status["location"]
          report = Blurb::Report.download(status["location"])
          expect(report).not_to be nil
        end
      end
    end

    context "given a campaigns recordType" do
      it "returns a campaigns report" do
        payload_response = Blurb::Report.create({
          "recordType" => Blurb::Report::CAMPAIGNS,
          "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          "metrics" => "impressions,clicks"
        })

        expect(payload_response).not_to be nil
      end
    end

    context "given a adGroups recordType" do
      it "returns a adGroups report" do
        payload_response = Blurb::Report.create({
          "recordType" => Blurb::Report::AD_GROUPS,
          "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          "metrics" => "impressions,clicks"
        })

        expect(payload_response).not_to be nil
      end
    end

    context "given a productAds recordType" do
      it "returns a productAds report" do
        payload_response = Blurb::Report.create({
          "recordType" => Blurb::Report::PRODUCT_ADS,
          "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          "metrics" => "impressions,clicks",
          "segment" => "query"
        })

        expect(payload_response).not_to be nil
      end
    end

    context "given an asins recordType" do
      it "returns an asins report" do
        payload_response = Blurb::Report.create({
          "recordType" => Blurb::Report::ASINS,
          "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
        })

        expect(payload_response).not_to be nil
      end
    end
  end

end
