# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
$:.push File.expand_path("../lib", __FILE__)
require "dora/version"

Gem::Specification.new do |s|
  s.name        = "dora"
  s.version     = Dora::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patrick Ward"]
  s.email       = ["yawpcast@gmail.com"] 
  s.homepage    = ["http://www.patrickward.com"]
  s.summary     = "Dojo Toolkit helpers for Rails 3" 
  s.description = "Dora helps you sing with Dojo and Rails. In more practical terms, she helps you create Dojo Toolkit markup in a Rails 3 environment."
  s.rubyforge_project = "dora"

  s.files       = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # s.add_dependency("rails", "~> 3.0.0")
  s.add_dependency("simple_form", "~> 1.3.1")

  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "rails", "~> 3.0.5"
  s.add_development_dependency "rspec-rails", "~> 2.5.0"
  s.add_development_dependency "nokogiri", "~> 1.4.4"
  s.add_development_dependency "capybara", "~> 0.4.1.2"
  s.add_development_dependency "watchr"
  s.add_development_dependency "spork", "~> 0.9.0.rc2"
  s.add_development_dependency "sqlite3-ruby", "1.2.5"

end
