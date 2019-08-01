require "spec_helper"

RSpec.describe Blurb::Account do
  let(:account) do
    client = Blurb::Client.new(
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"]
    )
    described_class.new(
      refresh_token: ENV["REFRESH_TOKEN"],
      region: "TEST",
      client: client
    )
  end

  describe "#initialize" do
    it "correctly initializes refresh token" do
      expect(account.refresh_token).to eql(ENV["REFRESH_TOKEN"])
    end
    it "correctly initializes api_url" do
      expect(account.api_url).to eql(described_class::API_URLS["TEST"])
    end
    it "correctly initialize profiles" do
      expect(account.profiles.length).to be > 0
    end
    it "correctly sets active profile to first profile" do
      expect(account.active_profile).to eql(account.profiles.first)
    end
  end

  describe '#set_active_profile' do
    it "correctly sets profile" do
      profile = account.profiles.sample
      account.set_active_profile(profile.profile_id)
      expect(account.active_profile).to eql(profile)
    end
  end

  describe '#get_profile' do
    it "correctly sets profile" do
      profile = account.profiles.sample
      expect(account.get_profile(profile.profile_id)).to eql(profile)
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
