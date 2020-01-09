# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socketlabs/version.rb'

Gem::Specification.new do |spec|
  spec.name        = 'socketlabs-ruby'
  spec.version     = SocketLabs::InjectionApi::VERSION
  spec.authors     = ['David Schrenker']
  spec.email       = 'developers@socketlabs.com'
  spec.summary     = 'SocketLabs Injection Api'
  spec.description = 'SocketLabs Email Delivery Python client library'
  spec.homepage    = 'https://github.com/socketlabs/socketlabs-ruby'

  spec.required_ruby_version = '>= 2.4'

  spec.license     = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']
  spec.add_dependency 'ruby_http_client', '~> 3.3.0'
  #spec.add_development_dependency 'sinatra', '>= 1.4.7', '< 3'
  #spec.add_development_dependency 'rake', '~> 0'
  #spec.add_development_dependency 'rspec'
  #spec.add_development_dependency 'pry'
  #spec.add_development_dependency 'faker'
  #spec.add_development_dependency 'rubocop'
  #spec.add_development_dependency 'minitest', '~> 5.9'
end