# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wildhorn/version'

Gem::Specification.new do |spec|
  spec.name          = 'wildhorn'
  spec.version       = Wildhorn::VERSION
  spec.authors       = ['Kevin Gisi']
  spec.email         = ['kevin@kevingisi.com']

  spec.summary       = 'A small gem for managing Jekyll-based podcasts'
  spec.description   = 'A small gem for managing Jekyll-based podcasts'
  spec.homepage      = 'http://github.com/gisikw/wildhorn'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'yt', '~> 0.25'
  spec.add_dependency 'soundcloud', '~> 0.3'
  spec.add_dependency 'taglib-ruby', '~> 0.7'
  spec.add_dependency 'redcarpet', '~> 3.3'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.42'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
