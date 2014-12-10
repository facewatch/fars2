# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fars2/version'

Gem::Specification.new do |spec|
  spec.name          = "fars2"
  spec.version       = Fars2::VERSION
  spec.authors       = ["Denyago", "Lightpower", "Alex Avoyants"]
  spec.email         = ["shhavel@gmail.com"]
  spec.summary       = %q{JSON serializers.}
  spec.description   = %q{JSON serializers make it easy to create serialization layer (like view in MVC) for JSON API project}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json"
  spec.add_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "database_cleaner"
end
