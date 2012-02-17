# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mobitex/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Aleksadner Dąbrowski', 'Karol Sarnacki']
  gem.email         = ['tjeden@rubysfera.pl', 'sodercober@gmail.com']
  gem.description   = "Ruby interface to Mobitex's Smscenter API"
  gem.summary       = "Ruby interface to Mobitex's Smscenter API"
  gem.homepage      = 'https://github.com/tjeden/smscenter'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'mobitex'
  gem.require_paths = ['lib']
  gem.version       = Mobitex::VERSION

  gem.add_development_dependency 'minitest', ['>= 2.0.0']
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'webmock'
end
