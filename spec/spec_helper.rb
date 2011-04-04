# encoding: utf-8
require "rspec"
require "active_record"
require "defaults"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
load File.dirname(__FILE__) + "/schema.rb"
