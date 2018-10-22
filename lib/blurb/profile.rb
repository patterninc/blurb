module Blurb
  class Profile < BaseResource

    def self.list()
      profile_request("/v2/profiles")
    end

    def self.retrieve(profile_id)
      profile_request("/v2/profiles/#{profile_id}")
    end
  end
end
