# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rindle/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Arthur Leonard Andersen"]
  gem.email         = ["leoc.git@gmail.com"]
  gem.description   = %q{The Rindle gem provides an object-oriented way to manage kindle collection data.}
  gem.summary       = %q{Access kindle collection data}
  gem.homepage      = "http://leoc.github.com/rindle"

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rindle"
  gem.require_paths = ["lib"]
  gem.version       = Rindle::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
end
