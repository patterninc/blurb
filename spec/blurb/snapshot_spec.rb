require "spec_helper"

RSpec.describe Blurb::Snapshot do
  include_context "shared setup"

  describe "#create" do
    context "given a keywords recordType" do
      it "returns a keywords snapshot" do
        expect(Blurb::Snapshot.create({
          "recordType" => Blurb::Snapshot::KEYWORDS,
          "stateFilter" => "enabled,paused,archived"
        })).not_to be nil

      end
    end
  end

end
