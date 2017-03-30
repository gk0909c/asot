# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asot/version'

Gem::Specification.new do |spec|
  spec.name          = 'asot'
  spec.version       = Asot::VERSION
  spec.authors       = ['gk0909c']
  spec.email         = ['gk0909c@gmail.com']

  spec.summary       = 'help to Automate Salesforce Operation Test.'
  spec.homepage      = 'https://github.com/gk0909c/asot.git'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'savon', '~> 2.11'
  spec.add_dependency 'rest-client', '~> 2.0'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'capybara', '~> 2.13'
  spec.add_development_dependency 'selenium-webdriver', '~> 3.3'
end
