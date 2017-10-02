module Blurb
  class Profile < BaseResource

    def self.list()
      profile_request("/v1/profiles")
    end
  end
end
