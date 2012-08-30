# -*- encoding: utf-8 -*-
require File.expand_path('../lib/git-awesome-diff/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Max Prokopiev", "Timur Vafin"]
  gem.email         = ["max-prokopiev@yandex.ru", "me@timurv.ru"]
  gem.description   = %q{Object Oriented Diffing for Git}
  gem.summary       = %q{Object Oriented Diffing for Git}
  gem.homepage      = "https://github.com/fs/git-awesome-diff"

  gem.add_development_dependency "grit"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "activesupport"
  gem.add_development_dependency "commander"
  gem.add_development_dependency "colorize"
  gem.add_development_dependency "rspec"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "git-awesome-diff"
  gem.require_paths = ["lib"]
  gem.version       = GitAwesomeDiff::VERSION
end
