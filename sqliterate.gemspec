# coding: utf-8

$:.push File.expand_path("../lib", __FILE__)

require 'sqliterate/version'

Gem::Specification.new do |s|
  s.name        = 'sqliterate'
  s.version     = SQLiterate::VERSION
  s.date        = '2015-01-02'
  s.summary     = "A SQL parser."
  s.description = "SQLiterate is a SQL parser."
  s.authors     = ["Emmanuel Bastien"]
  s.email       = 'os@ebastien.name'
  s.files       = Dir["lib/**/*", "LICENSE", "*.md"]
  s.homepage    = 'http://rubygems.org/gems/sqliterate'
  s.license     = 'MIT'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  s.add_runtime_dependency "polyglot", "~> 0.3"
  s.add_runtime_dependency "treetop",  "~> 1.5"
end
