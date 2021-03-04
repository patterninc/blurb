# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "blurb"
  spec.version       = "0.5.9"
  spec.authors       = ["dlbunker", "eamigo13", "smithworx"]
  spec.email         = ["evan@pattern.com"]

  spec.summary       = %q{Ruby gem for the Amazon Advertising API}
  spec.description   = %q{Amazon released a new Advertising API in 2017. This gem will integrate and allow you to make API calls to Amazon.}
  spec.homepage      = "https://github.com/iserve-products/blurb"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.3.0"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "faker", "~> 2.1.0"

  spec.add_runtime_dependency "rest-client", "~> 2.0"
  spec.add_runtime_dependency "oauth2", "~> 1.4.0"
  spec.add_runtime_dependency "activesupport"

end
