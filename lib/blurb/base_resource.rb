module Blurb
  class BaseResource
    attr_accessor :client_secret, :client_id, :refresh_token, :profile_id, :region

    SPONSORED_PRODUCTS = "sp"
    SPONSORED_BRANDS = "hsa"

    def initialize(account=Blurb.default_account)
      @client_secret = account[:client_secret]
      @client_id = account[:client_id]
      @refresh_token = account[:refresh_token]
      @profile_id = account[:profile_id]
      @region = account[:region]
    end

    def active_api_url
      case @region
      when "TEST"
        "https://advertising-api-test.amazon.com"
      when "NA"
        "https://advertising-api.amazon.com"
      when "EU"
        "https://advertising-api-eu.amazon.com"
      when "FE"
        "https://advertising-api-fe.amazon.com"
      end
    end

    def client
      return OAuth2::Client.new(
        "",
        "",
        :site => "https://api.amazon.com"
      )
    end

    def token_code(auth_code)
      response = client.request(:post, "/auth/o2/token",
        {
          body: {
            grant_type: "authorization_code",
            client_id: @client_id,
            code: auth_code,
            client_secret: @client_secret
          }
        }
      )

      return JSON.parse(response.body)
    end

    def retrieve_token(params = {}, opts = {})
      response = client.request(:post, "/auth/o2/token",
        {
          body: {
            grant_type: "refresh_token",
            client_id: @client_id,
            refresh_token: @refresh_token,
            client_secret: @client_secret
          }
        }
      )

      return JSON.parse(response.body)
    end

    def profile_request(api_path)
      access_token = retrieve_token()

      request_config = {
          method: :get,
          url: "#{active_api_url}#{api_path}",
          headers: {
            "Authorization" => "Bearer #{access_token['access_token']}",
            "Content-Type" => "application/json",
            "Amazon-Advertising-API-ClientId" => @client_id
          }
        }

      resp = RestClient::Request.execute(request_config)
      return JSON.parse(resp)
    end

    def get_request(api_path, opts = {})
      url = "#{active_api_url}#{api_path}"
      url = api_path if opts[:full_path]

      request_config = {
          method: :get,
          url: url,
          headers: headers_hash(opts),
          max_redirects: 0
        }

      return make_request(request_config)
    end

    def post_request(api_path, payload)
      request_config = {
          method: :post,
          url: "#{active_api_url}#{api_path}",
          payload: payload.to_json,
          headers: headers_hash
        }

      return make_request(request_config)
    end

    def put_request(api_path, payload)
      request_config = {
          method: :put,
          url: "#{active_api_url}#{api_path}",
          payload: payload.to_json,
          headers: headers_hash
        }

      return make_request(request_config)
    end

    def delete_request(api_path)
      request_config = {
          method: :delete,
          url: "#{active_api_url}#{api_path}",
          headers: headers_hash,
        }

      return make_request(request_config)
    end

    private

    def make_request(request_config)
      begin
        resp = RestClient::Request.execute(request_config)
      rescue RestClient::ExceptionWithResponse => err
        # If this happens, then we are downloading a report from the api, so we can simply download the location
        if err.response.code == 307
          return RestClient.get(err.response.headers[:location])
        else
          return JSON.parse(err.response.body)
        end
      end

      response = JSON.parse(resp) if resp
      return response
    end

    def headers_hash(opts = {})
      access_token = retrieve_token()

      headers_hash = {
        "Authorization" => "Bearer #{access_token['access_token']}",
        "Content-Type" => "application/json",
        "Amazon-Advertising-API-Scope" => @profile_id,
        "Amazon-Advertising-API-ClientId" => @client_id
      }

      headers_hash["Content-Encoding"] = "gzip" if opts[:gzip]

      return headers_hash
    end

    def setup_url_params(params, whitelist)
      whitelisted_params = params.select { |k,v| whitelist.include?(k) }
      return URI.encode_www_form(whitelisted_params)
    end
  end
end
