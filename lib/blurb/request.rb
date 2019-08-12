require 'active_support/core_ext/string'
require "rest-client"
require "blurb/base_class"

class Blurb
  class Request < BaseClass

    def initialize(url:, request_type:, payload: nil, headers:, url_params: nil)
      @url = setup_url(url, url_params)
      @payload = convert_payload(payload)
      @headers = headers
      @request_type = request_type
    end

    def request_config
      request_config = {
        method: @request_type,
        url: @url,
        headers: @headers
      }

      case @request_type
      when :get
        request_config[:max_redirects] = 0
      when :post, :put
        request_config[:payload] = @payload if @payload
      end

      return request_config
    end

    def make_request
      begin
        resp = RestClient::Request.execute(request_config())
      rescue RestClient::ExceptionWithResponse => err
        # If this happens, then we are downloading a report from the api, so we can simply download the location
        if err.response.code == 307
          return RestClient.get(err.response.headers[:location])
        else
          return JSON.parse(err.response.body)
        end
      end
      resp = convert_response(resp)
      return resp
    end

    private
      def setup_url(url, url_params)
        url += "?#{URI.encode_www_form(camelcase_keys(url_params))}" if url_params
        return url
      end

      def convert_payload(payload)
        return if payload.nil?
        payload = payload.map{|r| camelcase_keys(r)} if payload.class == Array
        payload = camelcase_keys(payload) if payload.class == Hash
        return payload.to_json
      end

      def convert_response(resp)
        resp = JSON.parse(resp)
        resp = resp.map{|r| underscore_keys(r)} if resp.class == Array
        resp = underscore_keys(resp) if resp.class == Hash
        #TODO convert to symbols recursively
        return resp
      end

      def camelcase_keys(hash)
        map = hash.map do |key,value|
          value = value.strftime('%Y%m%d') if value.class == Date || value.class == Time
          [key.to_s.camelize(:lower), value]
        end
        map.to_h
      end

      def underscore_keys(hash)
        hash.map{|k,v| [k.underscore.to_sym, v]}.to_h
      end

  end
end
