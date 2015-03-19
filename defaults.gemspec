require "./lib/defaults/version"

Gem::Specification.new do |s|
  s.name        = "defaults"
  s.version     = Defaults::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["fnando.vieira@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/defaults"
  s.summary     = "Set default values for ActiveRecord attributes"
  s.description = s.summary
  s.licenses    = ['MIT']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "activerecord", ">= 3.0.0"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "rspec"
  s.add_development_dependency "codeclimate-test-reporter"
end
