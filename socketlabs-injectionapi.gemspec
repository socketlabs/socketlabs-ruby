# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socketlabs/version.rb'

Gem::Specification.new do |spec|
  spec.name        = 'socketlabs-injectionapi'
  spec.version     = SocketLabs::InjectionApi::VERSION
  spec.authors     = ['David Schrenker', 'Praneeth Chandra', 'Reid Workman']
  spec.email       = 'developers@socketlabs.com'
  spec.summary     = 'SocketLabs Injection Api'
  spec.description = 'SocketLabs Email Delivery Ruby Client library'
  spec.homepage    = 'https://github.com/socketlabs/socketlabs-ruby'

  spec.required_ruby_version = '>= 3.1.2'

  spec.license     = 'MIT'
  files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(examples)/})
  end
  spec.files        = files
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

end
