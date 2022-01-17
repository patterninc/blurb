require "blurb/errors/base_exception"
class Blurb
  class RequestThrottled < BaseException
    def initialize(response)
      super("Request throttled", response)
    end
  end
end
