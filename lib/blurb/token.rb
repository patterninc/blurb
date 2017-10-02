module Blurb
  class Token

    def self.code(auth_code)
      response = Blurb::client.request(:post, "/auth/o2/token",
        {
          body: {
            grant_type: "authorization_code",
            client_id: Blurb.client_id,
            code: auth_code,
            client_secret: Blurb.client_secret
          }
        }
      )

      return JSON.parse(response.body)
    end

    def self.retrieve(params = {}, opts = {})
      response = Blurb::client.request(:post, "/auth/o2/token",
        {
          body: {
            grant_type: "refresh_token",
            client_id: Blurb.client_id,
            refresh_token: Blurb.refresh_token,
            client_secret: Blurb.client_secret
          }
        }
      )

      return JSON.parse(response.body)
    end
  end
end
