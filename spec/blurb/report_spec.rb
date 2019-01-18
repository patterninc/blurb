require "spec_helper"

RSpec.describe Blurb::Report do
  include_context "shared setup"

  describe "#create" do
    Blurb.test_env = false
    context "given a sponsoredProducts campaignType" do
      context "given a keywords recordType" do
        it "returns a keywords report" do
          sleep(3)
          payload_response = Blurb::Report.create({
            "recordType" => Blurb::Report::KEYWORDS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
            "segment" => "query"
          })
          expect(payload_response["status"]).to eq("IN_PROGRESS")

          status = Blurb::Report.status(payload_response["reportId"])

          if status && status["location"]
            report = Blurb::Report.download(status["location"])
            expect(report.code).to eq(200)
          end
        end
      end

      context "given a campaigns recordType" do
        it "returns a campaigns report" do
          sleep(3)
          payload_response = Blurb::Report.create({
            "recordType" => Blurb::Report::CAMPAIGNS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
            "metrics" => "impressions,clicks"
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a adGroups recordType" do
        it "returns a adGroups report" do
          sleep(3)
          payload_response = Blurb::Report.create({
            "recordType" => Blurb::Report::AD_GROUPS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a productAds recordType" do
        it "returns a productAds report" do
          sleep(3)
          payload_response = Blurb::Report.create({
            "recordType" => Blurb::Report::PRODUCT_ADS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given an asins recordType" do
        it "returns an asins report" do
          sleep(3)
          payload_response = Blurb::Report.create({
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "recordType" => Blurb::Report::ASINS,
            "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a targets recordType" do
        it "returns a target report" do
          sleep(3)
          payload_response = Blurb::Report.create({
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "recordType" => Blurb::Report::TARGETS,
            "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end
    end
    context "given a sponsoredBrands campaignType" do
      context "given a keywords recordType" do
        it "returns a keywords report" do
          sleep(3)
          payload_response = Blurb::Report.create({
            "recordType" => Blurb::Report::KEYWORDS,
            "campaignType" => Blurb::Report::SPONSORED_BRANDS,
            "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
            "segment" => "query"
          })
          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a campaigns recordType" do
        it "returns a campaigns report" do
          sleep(3)
          payload_response = Blurb::Report.create({
            "recordType" => Blurb::Report::CAMPAIGNS,
            "campaignType" => Blurb::Report::SPONSORED_BRANDS,
            "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
            "metrics" => "impressions,clicks"
          })
          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a adGroups recordType" do
        it "returns a adGroups report" do
          sleep(3)
          payload_response = Blurb::Report.create({
            "recordType" => Blurb::Report::AD_GROUPS,
            "campaignType" => Blurb::Report::SPONSORED_BRANDS,
            "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          })
          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end
    end
  end
end
