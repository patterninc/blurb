require "blurb/base_class"

class Blurb
  class Client < BaseClass
    attr_accessor :client_id, :client_secret, :reports_api_version

    def initialize(client_id:, client_secret:, reports_api_version:)
      @client_id = client_id
      @client_secret = client_secret
      @reports_api_version = reports_api_version
    end
  end
end
