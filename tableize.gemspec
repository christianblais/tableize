# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require './lib/version'

Gem::Specification.new do |s|
  s.name        = "tableize"
  s.version     = Tableize::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Christian Blais"]
  s.email       = ["christ.blais@gmail.com"]
  s.homepage    = "http://github.com/christianblais/tableize"
  s.summary     = "Simple table helper"
  s.description = "Simple table helper"

  s.files = `git ls-files`.split("\n")

  s.require_paths = ['lib', 'test']
end