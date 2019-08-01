require "spec_helper"

RSpec.describe Blurb::Profile do
  let(:profile) do
    client = Blurb::Client.new(
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"]
    )
    account = Blurb::Account.new(
      refresh_token: ENV["REFRESH_TOKEN"],
      region: "TEST",
      client: client
    )
    described_class.new(
      profile_id: ENV["PROFILE_ID"],
      account: account
    )
  end

  describe "#initialize" do
    it "correctly initializes profile id" do
      expect(profile.profile_id).to eql(ENV["PROFILE_ID"])
    end
  end

  describe '#profile_details' do
    it "retrieves profile" do
      expect(profile.profile_details()[:profile_id].to_i).to eql(profile.profile_id.to_i)
    end
  end
end
