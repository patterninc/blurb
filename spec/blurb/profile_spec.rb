require "spec_helper"

RSpec.describe Blurb::Profile do
  include_context "shared setup"

  describe "#list" do
    it "returns profiles" do
      profiles = Blurb::Profile.list()
      expect(profiles).not_to be nil

      profiles.each do | p |
        expect(Blurb::Profile.retrieve(p["profileId"])).not_to be nil
      end
    end
  end

end
