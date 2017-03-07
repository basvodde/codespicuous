# encoding: utf-8
require File.expand_path('../lib/codespicuous/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'codespicuous'
  gem.version = Codespicuous::VERSION
  gem.date    = Date.today.to_s

  gem.summary = "Codespicuous is a tool for generating team based metrics from code"
  gem.description = "Codespicuous is a tool for generating several different metrics from codebases to gain insight in how the teams are working."

  gem.authors  = ['Bas Vodde']
  gem.email    = 'basv@odd-e.com'
  gem.homepage = 'https://github.com/basvodde/codespicuous'

  gem.add_dependency('rake')
  gem.add_development_dependency('rspec', [">= 2.0.0"])

  gem.files = `git ls-files -- {.,test,spec,lib}/*`.split("\n")
end
