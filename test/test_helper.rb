require "simplecov"
SimpleCov.start

require "bundler/setup"
require "active_record"
require "defaults"

require "minitest/utils"
require "minitest/autorun"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
load File.dirname(__FILE__) + "/schema.rb"
