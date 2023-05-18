# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rsbe/client/version'

Gem::Specification.new do |spec|
  spec.name          = "rsbe-client"
  spec.version       = Rsbe::Client::VERSION
  spec.authors       = ["jgpawletko"]
  spec.email         = ["jgpawletko@gmail.com"]
  spec.summary       = %q{Client library for interacting with rsbe API.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "rspec-its", "~> 1.0.1"
  spec.add_development_dependency "vcr", "~> 2.9.3"
  spec.add_development_dependency "webmock", "~> 1.18.0"
  spec.add_development_dependency "pry", "~> 0.10.1"

  spec.add_dependency "faraday", "~> 0.9.0"
  spec.add_dependency "activesupport", "~> 4.2.11"
end
