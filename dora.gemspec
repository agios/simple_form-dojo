# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name        = "dora"
  s.version     = Dora::VERSION
  s.authors     = ["Patrick Ward"]
  s.email       = ["yawpcast@gmail.com"] 
  s.homepage    = ["http://www.patrickward.com"]
  s.summary     = "Dojo Toolkit helpers for Rails 3" 
  s.description = "Dora helps you sing with Dojo and Rails. In more practical terms, she helps you create Dojo Toolkit markup in a Rails 3 environment."
  s.files       = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.add_dependency("rails", "~> 3.0.0")
  s.require_paths = ["lib"]
end
