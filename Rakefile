require "./lib/defaults/version"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |t|
  t.ruby_opts = %w[ -Ilib -Ispec ]
end

begin
  require "jeweler"

  JEWEL = Jeweler::Tasks.new do |gem|
    gem.name = "defaults"
    gem.version = Defaults::Version::STRING
    gem.summary = "Set default values for ActiveRecord attributes"
    gem.description = "Set default values for ActiveRecord attributes"
    gem.authors = ["Nando Vieira"]
    gem.email = "fnando.vieira@gmail.com"
    gem.homepage = "http://github.com/fnando/has_defaults"
    gem.has_rdoc = false
    gem.files = FileList["init.rb", "Gemfile", "Rakefile", "README.rdoc", "defaults.gemspec", "{lib,spec}/**/*"]
    gem.add_development_dependency "rspec", ">= 2.0.0"
    gem.add_dependency "activerecord"
  end

  Jeweler::GemcutterTasks.new
rescue LoadError => e
  puts "You don't have Jeweler installed, so you won't be able to build gems."
end
