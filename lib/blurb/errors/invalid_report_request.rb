require "blurb/errors/base_exception"
class Blurb
  class InvalidReportRequest < BaseException
    def initialize(response)
      super("Invalid report response", response)
    end
  end
end
