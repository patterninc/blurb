class Blurb
  class BaseException < StandardError
    attr_reader :response

    def initialize(message, response)
      super("#{message}\nResponse: #{response.body}")
      @response = response
    end
  end
end
