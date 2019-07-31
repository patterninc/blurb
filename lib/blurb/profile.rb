require "blurb/account"
require "blurb/requests"

module Blurb
  class Profile < Account
    include Requests
    attr_accessor :profile_id

    def initialize(client_id:, client_secret:, refresh_token:, region:, profile_id:)
      super(
        client_id: client_id,
        client_secret: client_secret,
        refresh_token: refresh_token,
        region: region
      )
      @profile_id = profile_id
    end

    def retrieve_profile
      super(@profile_id)
    end
  end
end
