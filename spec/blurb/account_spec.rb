require "spec_helper"

RSpec.describe Blurb::Account do
  let(:account) do
    described_class.new(
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"],
      refresh_token: ENV["REFRESH_TOKEN"],
      region: "TEST"
    )
  end

  describe "#initialize" do
    it "correctly initializes refresh token" do
      expect(account.refresh_token).to eql(ENV["REFRESH_TOKEN"])
    end
    it "correctly initializes client secret" do
      expect(account.client_secret).to eql(ENV["CLIENT_SECRET"])
    end
    it "correctly initializes client id" do
      expect(account.client_id).to eql(ENV["CLIENT_ID"])
    end
    it "correctly initializes api_url" do
      expect(account.api_url).to eql(described_class::API_URLS["TEST"])
    end
  end

  describe "#profile_list" do
    it "returns profiles" do
      profiles = account.profile_list()
      expect(profiles.length).to be > 0
    end
  end

  describe '#retrive_profile' do
    it "retrieves profile" do
      profiles = account.profile_list()

      profiles.each do | p |
        expect(account.retrieve_profile(p["profileId"])).not_to be nil
      end
    end
  end
end
