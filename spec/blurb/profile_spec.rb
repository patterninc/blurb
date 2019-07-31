require "spec_helper"

RSpec.describe Blurb::Profile do
  let(:profile) do
    described_class.new(
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"],
      refresh_token: ENV["REFRESH_TOKEN"],
      refresh_token: ENV["REFRESH_TOKEN"],
      profile_id: ENV["PROFILE_ID"].to_i,
      region: "TEST"
    )
  end

  describe "#initialize" do
    it "correctly initializes refresh token" do
      expect(profile.refresh_token).to eql(ENV["REFRESH_TOKEN"])
    end
    it "correctly initializes client secret" do
      expect(profile.client_secret).to eql(ENV["CLIENT_SECRET"])
    end
    it "correctly initializes client id" do
      expect(profile.client_id).to eql(ENV["CLIENT_ID"])
    end
    it "correctly initializes api_url" do
      expect(profile.api_url).to eql(described_class::API_URLS["TEST"])
    end
    it "correctly initializes profile id" do
      expect(profile.profile_id).to eql(ENV["PROFILE_ID"])
    end
  end

  describe '#retrive_profile' do
    it "retrieves profile" do
      expect(profile.retrieve_profile()["profileId"]).to eql(profile.profile_id)
    end
  end
end
