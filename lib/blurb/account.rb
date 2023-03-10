require "oauth2"
require "blurb/client"
require "blurb/profile"

class Blurb
  class Account < BaseClass
    attr_accessor :refresh_token, :api_url, :client, :profiles, :active_profile

    API_URLS = {
      "TEST" => "https://advertising-api-test.amazon.com",
      "NA" => "https://advertising-api.amazon.com",
      "EU" => "https://advertising-api-eu.amazon.com",
      "FE" => "https://advertising-api-fe.amazon.com"
    }

    def initialize(refresh_token:, region:, client:, profile_id: nil)
      @refresh_token = refresh_token
      @api_url = API_URLS[region]
      @client = client
      @token_refreshed_at = Process.clock_gettime(Process::CLOCK_MONOTONIC) # current time
      @authorization_token = retrieve_token
      initialize_profiles(profile_id)
    end

    def initialize_profiles(profile_id=nil)
      @profiles = []
      if profile_id
        @profiles << Profile.new(
          profile_id: profile_id,
          account: self
        )
      else
        amazon_profiles = profile_list()
        amazon_profiles.each do |p|
          @profiles << Profile.new(
            profile_id: p[:profile_id],
            account: self
          )
        end
      end
      @active_profile = @profiles.first
    end

    def set_active_profile(profile_id)
      @active_profile = get_profile(profile_id)
    end

    def get_profile(profile_id)
      @profiles.find{ |p| p.profile_id == profile_id }
    end

    def profile_list
      profile_request("/v2/profiles")
    end

    def retrieve_profile(profile_id)
      profile_request("/v2/profiles/#{profile_id}")
    end

    def retrieve_token
      current_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      elapsed_time = current_time - @token_refreshed_at

      # refresh the token if it's been over an hour
      if @authorization_token.nil? || elapsed_time >= 3600 # 1 hour #Look at using amazons expires_inblurb/
        response = authorization_client.request(:post, "/auth/o2/token",
          {
            body: {
              grant_type: "refresh_token",
              client_id: @client.client_id,
              refresh_token: @refresh_token,
              client_secret: @client.client_secret
            }
          }
        )

        @authorization_token = JSON.parse(response.body)['access_token']
        @token_refreshed_at = current_time
      end

      return @authorization_token
    end

    private

      def profile_request(api_path)
        request = Request.new(
          url: "#{@api_url}#{api_path}",
          request_type: :get,
          headers: {
            "Authorization" => "Bearer #{retrieve_token()}",
            "Content-Type" => "application/json",
            "Amazon-Advertising-API-ClientId" => @client.client_id
          }
        )

        request.make_request
      end

      def authorization_client
        OAuth2::Client.new(
          '',
          '',
          site: 'https://api.amazon.com',
          ssl: { version: :TLSv1 }
        )
      end
  end
end
