# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef/taste/version'

Gem::Specification.new do |spec|
  spec.name          = "chef-taste"
  spec.version       = Chef::Taste::VERSION
  spec.authors       = ["Kannan Manickam"]
  spec.email         = ["me@arangamani.net"]
  spec.description   = %q{This gem checks if updated versions of dependent cookbooks are available for the cookbook}
  spec.summary       = %q{Chef cookbook dependency update checker}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "solve", "~> 0.8.0"
  spec.add_dependency "berkshelf", "~> 2.0.10"
  spec.add_dependency "thor", "~> 0.18.0"
end
