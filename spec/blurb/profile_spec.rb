require "spec_helper"

RSpec.describe Blurb::Profile do
  let(:profile) { Blurb.new().active_profile }

  describe "#initialize" do
    it "correctly initializes profile id" do
      expect(profile.profile_id).to eql(ENV["BLURB_PROFILE_ID"])
    end
  end

  describe '#profile_details' do
    it "retrieves profile" do
      expect(profile.profile_details()[:profile_id].to_i).to eql(profile.profile_id.to_i)
    end
  end
end
