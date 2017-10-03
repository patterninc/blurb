require "spec_helper"

RSpec.describe Blurb::Report do
  include_context "shared setup"

  describe "#create" do
    context "given a keywords recordType" do
      it "returns a keywords report" do
        Blurb.test_env = false
        payload_response = Blurb::Report.create({
          "recordType" => Blurb::Report::KEYWORDS,
          "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
          "metrics" => "impressions,clicks"
        })

        expect(payload_response).not_to be nil

        status = Blurb::Report.status(payload_response["reportId"])
        expect(status).not_to be nil

        RestClient.log = 'stdout'
        report = Blurb::Report.download(status["location"])
        expect(report).not_to be nil
      end
    end
  end

end
