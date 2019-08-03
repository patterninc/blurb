require "spec_helper"

RSpec.describe ReportRequests do
  before(:all) do
    @account = Account.new(
      refresh_token: ENV["REFRESH_TOKEN"],
      region: "TEST",
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"]
    )
    @report_type = ""
  end

  RSpec.shared_examples "reports" do
    it "requests and retrieves campaigns reports" do
      report_types.each do |report_type|
        @report_type = report_type
        @response = resource.create(record_type: report_type)
        expect(@response[:status]).to eq("IN_PROGRESS")
        @retrieve_response = resource.retrieve(@response[:report_id])
        expect(@retrieve_response[:report_id]).to be_truthy
      end
    end
  end

  context "sponsored brands" do
    let(:resource) {@account.active_profile.reports(:sb)}
    let(:report_types) {[:campaigns, :ad_groups, :keywords]}

    include_examples "reports"
  end

  context "sponsored products" do
    let(:resource) {@account.active_profile.reports(:sp)}
    let(:report_types) {[:campaigns, :ad_groups, :keywords, :product_ads, :targets]}

    include_examples "reports"
  end

  after(:each) do |example|
    if example.exception
      puts "report_type: #{@report_type}"
      puts "response: #{@response}"
      puts "retrieve_response: #{@retrieve_response}"
    end
  end
end
