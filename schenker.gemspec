# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'schenker/version'

Gem::Specification.new do |spec|
  spec.name          = "schenker"
  spec.version       = Schenker::VERSION
  spec.authors       = ["Ilkka Sopanen"]
  spec.email         = ["ilkka.sopanen@gmail.com"]
  spec.summary       = %q{Unofficial gem for the delivery points of Schenker.}
  spec.description   = %q{Should be used to get the nearest delivery points
                          data for a valid Finnish post number.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
