require "blurb/client"

module Blurb
  class Account < Client
    attr_accessor :refresh_token, :api_url

    API_URLS = {
      "TEST" => "https://advertising-api-test.amazon.com",
      "NA" => "https://advertising-api.amazon.com",
      "EU" => "https://advertising-api-eu.amazon.com",
      "FE" => "https://advertising-api-fe.amazon.com"
    }

    def initialize(client_id:, client_secret:, refresh_token:, region:)
      super(client_id: client_id, client_secret: client_secret)
      @refresh_token = refresh_token
      @api_url = API_URLS[region]
      @token_refreshed_at = Process.clock_gettime(Process::CLOCK_MONOTONIC) # current time
      @authorization_token = retrieve_token
    end

    def profile_list
      profile_request("/v2/profiles")
    end

    def retrieve_profile(profile_id)
      profile_request("/v2/profiles/#{profile_id}")
    end

    private
      def profile_request(api_path)
        request_config = {
            method: :get,
            url: "#{@api_url}#{api_path}",
            headers: {
              "Authorization" => "Bearer #{retrieve_token()}",
              "Content-Type" => "application/json",
              "Amazon-Advertising-API-ClientId" => @client_id
            }
          }

        resp = RestClient::Request.execute(request_config)
        return JSON.parse(resp)
      end

      def authorization_client
        return OAuth2::Client.new(
          "",
          "",
          :site => "https://api.amazon.com"
        )
      end

      def retrieve_token
        current_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        elapsed_time = current_time - @token_refreshed_at

        # refresh the token if it's been over an hour
        if @authorization_token.nil? || elapsed_time >= 3600 # 1 hour
          response = authorization_client.request(:post, "/auth/o2/token",
            {
              body: {
                grant_type: "refresh_token",
                client_id: @client_id,
                refresh_token: @refresh_token,
                client_secret: @client_secret
              }
            }
          )

          @authorization_token = JSON.parse(response.body)['access_token']
          @token_refreshed_at = current_time
        end

        return @authorization_token
      end
  end
end
