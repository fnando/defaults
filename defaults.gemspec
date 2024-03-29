# frozen_string_literal: true

require "./lib/defaults/version"

Gem::Specification.new do |s|
  s.name        = "defaults"
  s.version     = Defaults::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["me@fnando.com"]
  s.homepage    = "http://rubygems.org/gems/defaults"
  s.summary     = "Set default values for ActiveRecord attributes"
  s.description = s.summary
  s.licenses    = ["MIT"]
  s.required_ruby_version = ">= 2.7"
  s.metadata["rubygems_mfa_required"] = "true"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`
                    .split("\n")
                    .map {|file| File.basename(file) }
  s.require_paths = ["lib"]

  s.add_dependency "activerecord"
  s.add_development_dependency "minitest"
  s.add_development_dependency "minitest-utils"
  s.add_development_dependency "pry-meta"
  s.add_development_dependency "rake"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "rubocop-fnando"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
end
