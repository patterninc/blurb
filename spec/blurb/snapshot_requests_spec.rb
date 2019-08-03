require "spec_helper"

RSpec.describe Profile do
  before(:all) do
    @account = Account.new(
      refresh_token: ENV["REFRESH_TOKEN"],
      region: "TEST",
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"]
    )
    @snap = ""
  end

  RSpec.shared_examples "snapshots" do
    it "requests and retrieves campaigns snapshots" do
      snapshot_types.each do |snap|
        @snap = snap
        @response = resource.create(snap)
        expect(@response[:status]).to eq("IN_PROGRESS")
        @retrieve_response = resource.retrieve(@response[:snapshot_id])
        expect(@retrieve_response[:snapshot_id]).to be_truthy
      end
    end
  end

  context "sponsored brands" do
    let(:resource) {@account.active_profile.snapshots(:sb)}
    let(:snapshot_types) {['campaigns', 'keywords']}

    # sb snapshot generation fails in sandbox environment
    # include_examples "snapshots"
  end

  context "sponsored products" do
    let(:resource) {@account.active_profile.snapshots(:sp)}
    let(:snapshot_types) {['campaigns', 'adGroups', 'keywords', 'negativeKeywords', 'campaignNegativeKeywords', 'productAds', 'targets', 'negativeTargets']}

    include_examples "snapshots"
  end

  after(:each) do |example|
    if example.exception
      puts "snapshot: #{@snap}"
      puts "response: #{@response}"
      puts "retrieve_response: #{@retrieve_response}"
    end
  end
end
