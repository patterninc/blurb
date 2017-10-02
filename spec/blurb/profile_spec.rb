require "spec_helper"

RSpec.describe Blurb::Profile do
  include_context "shared setup"

  describe "#list" do
    it "returns profiles" do
      expect(Blurb::Profile.list()).not_to be nil
    end
  end

end
