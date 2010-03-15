$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"

require "rubygems"
require "active_record"
require "spec"
require File.dirname(__FILE__) + "/../init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
load File.dirname(__FILE__) + "/schema.rb"

alias :doing :lambda
