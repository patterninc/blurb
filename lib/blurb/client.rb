require "blurb/base_class"

class Blurb
  class Client < BaseClass
    attr_accessor :client_id, :client_secret, :api_version

    def initialize(client_id:, client_secret:, api_version:)
      @client_id = client_id
      @client_secret = client_secret
      @api_version = api_version
    end
  end
end
