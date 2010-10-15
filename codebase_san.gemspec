# -*- encoding: utf-8 -*-
require File.expand_path("../lib/codebase_san/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "codebase_san"
  s.version     = CodebaseSan::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Neil Middleton"
  s.email       = "neil.middleton@gmail.com"
  s.homepage    = "http://rubygems.org/gems/codebase_san"
  s.summary     = "Integration between heroku_san and CodebaseHQ.com"
  s.description = "Provides notifications of heroku deployments to CodebaseHQ.com"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "codebase_san"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_dependency "heroku_san", "1.0.1"
  s.add_dependency "codebase", "4.0.4"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
