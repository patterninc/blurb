require 'blurb/request'
require "blurb/base_class"

class RequestCollection < BaseClass

  def initialize(headers:, base_url:)
    @base_url = base_url
    @headers = headers
  end

  def list(url_params=nil)
    execute_request(
      request_type: :get,
      url_params: url_params
    )
  end

  def list_extended(url_params=nil)
    execute_request(
      api_path: "/extended",
      request_type: :get,
      url_params: url_params
    )
  end

  def retrieve(resource_id)
    execute_request(
      api_path: "/#{resource_id}",
      request_type: :get
    )
  end

  def retrieve_extended(resource_id)
    execute_request(
      api_path: "/extended/#{resource_id}",
      request_type: :get
    )
  end

  def create(**create_params)
    create_bulk([create_params])
  end

  def create_bulk(create_array)
    execute_bulk_request(
      request_type: :post,
      payload: create_array,
      api_limit: 100
    )
  end

  def update(**update_params)
    update_bulk([update_params])
  end

  def update_bulk(update_array)
    execute_bulk_request(
      request_type: :put,
      payload: update_array,
      api_limit: 100
    )
  end

  def delete(resource_id)
    execute_request(
      api_path: "/#{resource_id}",
      request_type: :delete
    )
  end

  private

    def execute_request(api_path: "", request_type:, payload: nil, url_params: nil)
      url = "#{@base_url}#{api_path}"

      request = Request.new(
        url: url,
        url_params: url_params,
        request_type: request_type,
        payload: payload,
        headers: @headers
      )

      request.make_request
    end

    # Split up bulk requests to match the api limit
    def execute_bulk_request(api_limit:, **execute_request_params)
      results = []
      payloads = execute_request_params[:payload].each_slice(api_limit).to_a
      payloads.each do |p|
        results << execute_request(execute_request_params)
      end
      results.flatten
    end
end
