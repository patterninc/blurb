module Blurb
  class Profile < BaseResource

    def list()
      profile_request("/v2/profiles")
    end

    def retrieve(profile_id)
      profile_request("/v2/profiles/#{profile_id}")
    end
  end
end
