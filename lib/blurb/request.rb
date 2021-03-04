require 'active_support/core_ext/string'
require "rest-client"
require "blurb/base_class"
require "blurb/errors/request_throttled"
require "blurb/errors/invalid_report_request"
require "blurb/errors/failed_request"

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
      log("request type", @request_type)
      log("request url", @url)
      log("headers", @headers)
      log("payload", @payload) if @payload
      return request_config
    end

    def make_request
      begin
        resp = RestClient::Request.execute(request_config())
        log("response", resp)
      rescue RestClient::TooManyRequests => err
        raise RequestThrottled.new(JSON.parse(err.response.body))
      rescue RestClient::TemporaryRedirect => err
        return RestClient.get(err.response.headers[:location])  # If this happens, then we are downloading a report from the api, so we can simply download the location
      rescue RestClient::NotAcceptable => err
        if @url.include?("report")
          raise InvalidReportRequest.new(JSON.parse(err.response.body))
        else
          raise err
        end
      rescue RestClient::ExceptionWithResponse => err
        if err.response.present?
          raise FailedRequest.new(JSON.parse(err.response.body))
        else 
          raise err
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
        payload = camelcase_keys(payload)
        return payload.to_json
      end

      def convert_response(resp)
        resp = JSON.parse(resp)
        resp = underscore_keys(resp)
        return resp
      end

      def camelcase_keys(value)
        case value
          when Array
            value.map { |v| camelcase_keys(v) }
          when Hash
            Hash[value.map { |k, v| [camelcase_key(k), camelcase_keys(v)] }]
          else
            value = value.strftime('%Y%m%d') if [Date, Time, ActiveSupport::TimeWithZone].include?(value.class)
            value
         end
      end

      def camelcase_key(k)
        return k if k.to_s == k.to_s.upcase
        k.to_s.camelize(:lower)
      end

      def underscore_keys(value)
        case value
          when Array
            value.map { |v| underscore_keys(v) }
          when Hash
            Hash[value.map { |k, v| [underscore_key(k), underscore_keys(v)] }]
          else
            value
         end
      end

      def underscore_key(k)
        k.to_s.underscore.to_sym
      end

      def log(header, message)
        if ENV["BLURB_LOGGING"]
          puts "\n"
          puts header.upcase
          puts message
          puts "\n"
        end
      end

  end
end
