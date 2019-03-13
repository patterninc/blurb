require "spec_helper"

RSpec.describe Blurb::Snapshot do
  include_context "shared setup"

  describe "#create" do
    context "given a sponsoredProducts campaignType" do
      context "given a keywords recordType" do
        it "returns a keywords snapshot" do
          sleep(3)
          payload_response = @snapshot_instance.create({
            "recordType" => Blurb::Snapshot::KEYWORDS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "stateFilter" => "enabled,paused,archived"
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")

          status = @snapshot_instance.status(payload_response["snapshotId"])

          if status && status["location"]
            report = @snapshot_instance.download(status["location"])
            expect(report).not_to be nil
          end
        end
      end

      context "given a campaign recordType" do
        it "returns a campaign snapshot" do
          sleep(3)
          payload_response = @snapshot_instance.create({
            "recordType" => Blurb::Snapshot::CAMPAIGNS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "stateFilter" => "enabled,paused,archived"
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a ad_group recordType" do
        it "returns a ad_group snapshot" do
          sleep(3)
          payload_response = @snapshot_instance.create({
            "recordType" => Blurb::Snapshot::AD_GROUPS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "stateFilter" => "enabled,paused,archived"
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a product_ad recordType" do
        it "returns a product_ad snapshot" do
          sleep(3)
          payload_response = @snapshot_instance.create({
            "recordType" => Blurb::Snapshot::PRODUCT_ADS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "stateFilter" => "enabled,paused,archived"
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a negativeKeywords recordType" do
        it "returns a negativeKeywords snapshot" do
          sleep(3)
          payload_response = @snapshot_instance.create({
            "recordType" => Blurb::Snapshot::NEGATIVE_KEYWORDS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "stateFilter" => "enabled,paused,archived"
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a campaignNegativeKeywords recordType" do
        it "returns a campaignNegativeKeywords snapshot" do
          sleep(3)
          payload_response = @snapshot_instance.create({
            "recordType" => Blurb::Snapshot::CAMPAIGN_NEGATIVE_KEYWORDS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "stateFilter" => "enabled,paused,archived"
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end

      context "given a targets recordType" do
        it "returns a targets snapshot" do
          sleep(3)
          payload_response = @snapshot_instance.create({
            "recordType" => Blurb::Snapshot::TARGETS,
            "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
            "stateFilter" => "enabled,paused,archived"
          })

          expect(payload_response["status"]).to eq("IN_PROGRESS")
        end
      end
    end

    # Sponsored Brands Snapshots still aren't working on the Amazon Advertising API.
    # context "given a sponsoredBrands campaignType" do
    #   Blurb.test_env = false
    #   context "given a keywords recordType" do
    #     it "returns a keywords snapshot" do
    #       sleep(3)
    #       payload_response = @snapshot_instance.create({
    #         "recordType" => Blurb::Snapshot::KEYWORDS,
    #         "campaignType" => Blurb::Report::SPONSORED_BRANDS,
    #         "stateFilter" => "enabled,paused,archived"
    #       })
    #       expect(payload_response["status"]).to eq("IN_PROGRESS")
    #     end
    #   end
    #
    #   context "given a campaign recordType" do
    #     it "returns a campaign snapshot" do
    #       sleep(3)
    #       payload_response = @snapshot_instance.create({
    #         "recordType" => Blurb::Snapshot::CAMPAIGNS,
    #         "campaignType" => Blurb::Report::SPONSORED_BRANDS,
    #         "stateFilter" => "enabled,paused,archived"
    #       })
    #
    #       expect(payload_response["status"]).to eq("IN_PROGRESS")
    #     end
    #   end
    # end
  end

end
