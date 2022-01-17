require "blurb/errors/base_exception"
class Blurb
  class FailedRequest < BaseException
    def initialize(response)
      super("Error in response", response)
    end
  end
end
