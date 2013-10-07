# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ebx_deliver/version'

Gem::Specification.new do |spec|
  spec.name          = "ebx_deliver"
  spec.version       = EbxDeliver::VERSION
  spec.authors       = ["Alex Bullard"]
  spec.email         = ["abullrd@gmail.com"]
  spec.description   = "eb eXtended cross region db command distributor"
  spec.summary       = "Distributes writes to Amazon's DynamoDB through SNS to allow for multiple cross region databases"
  spec.homepage      = "https://github.com/Funnerator/ebx_deliver.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency("dynamoid", "~> 0.7.1")
  spec.add_runtime_dependency("aws-sdk", "~> 1.17.0")
  spec.add_runtime_dependency("pry", "> 0")
end
