# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "bundler/setup"
require "active_record"
require "defaults"

require "minitest/utils"
require "minitest/autorun"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

load "#{__dir__}/schema.rb"
