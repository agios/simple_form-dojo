# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
$:.push File.expand_path("../lib", __FILE__)
require "simple_form-dojo/version"

Gem::Specification.new do |s|
  s.name        = "simple_form-dojo"
  s.version     = SimpleFormDojo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patrick Ward"]
  s.email       = ["yawpcast@gmail.com"] 
  s.homepage    = "http://www.patrickward.com"
  s.summary     = "Dojo Toolkit helpers for Rails 3" 
  s.description = "SimpleFormDojo is a collection of helpers for use with Dojo and Rails. The goal of the project is to make it simple to create Dijit elements using the existing Rails helper infrastructure."
  s.rubyforge_project = "simple_form-dojo"

  s.files       = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("simple_form", "~> 2.1.0")

  s.add_development_dependency "rspec", "~> 2.12.0"
  s.add_development_dependency "rails", "~> 3.2.9"
  s.add_development_dependency "rspec-rails", "~> 2.12.0"
  s.add_development_dependency "rspec-html-matchers"
  s.add_development_dependency "nokogiri", "~> 1.5.5"
  s.add_development_dependency "capybara", "~> 2.0.1"
  s.add_development_dependency "spork", "~> 0.9.2"
  s.add_development_dependency "sqlite3", "~> 1.3.6"
  s.add_development_dependency "factory_girl_rails", "~> 4.1.0"
  s.add_development_dependency "database_cleaner", "~> 0.9.1"
  s.add_development_dependency "watchr"
  s.add_development_dependency "awesome_print"
end
