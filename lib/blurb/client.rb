module Blurb
  class Client
    attr_accessor :client_id, :client_secret

    def initialize(client_id:, client_secret:)
      @client_id = client_id
      @client_secret = client_secret
    end
  end
end
