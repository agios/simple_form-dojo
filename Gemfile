source "http://rubygems.org"

# gem dependencies can be found in simple_form-dojo.gemspec
gemspec

if RUBY_PLATFORM=='java'
  @dependencies.delete_if {|d| d.name == 'sqlite3' }
  gem 'jdbc-sqlite3'
  gem 'activerecord-jdbcsqlite3-adapter', require: false
end
