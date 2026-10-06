# frozen_string_literal: true

module Fixtures
  DIR = File.expand_path('../fixtures', __dir__)

  def fixture(name)
    File.read(File.join(DIR, name))
  end
end

RSpec.configure { |config| config.include Fixtures }
