# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cubes/version'

Gem::Specification.new do |spec|
  spec.name          = 'cubes'
  spec.version       = Cubes::VERSION
  spec.authors       = ['David Guilherme']
  spec.email         = ['davidlguilherme@gmail.com']

  spec.summary       = 'A Ruby wrapper for Cubes OLAP Server'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'byebug'
  spec.add_dependency 'faraday'
  spec.add_dependency 'net-http-persistent', '~> 2.9.4'
end
