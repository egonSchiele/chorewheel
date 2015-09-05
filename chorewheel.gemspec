require File.expand_path(File.join(__FILE__, "../lib/chorewheel/version"))

Gem::Specification.new do |s|
  s.name        = "chorewheel"
  s.version     = ChoreWheel::VERSION
  s.summary     = "Simple chore scheduler in Ruby."
  s.description = "Make a chore wheel, with options for specifying multiple people, vacation days, etc."
  s.author      = "Aditya Bhargava"
  s.email       = "bluemangroupie@gmail.com"
  s.files       = `git ls-files`.split("\n")
  s.homepage    = "http://github.com/egonSchiele/chorewheel"
end
