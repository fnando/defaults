# encoding: utf-8
require "spec_helper"

class Donut < ActiveRecord::Base
  attr_accessor :class_name

  defaults :flavor => "cream",
           :name => "Cream",
           :maker => proc { "Dunkin Donuts" },
           :class_name => proc {|donut| donut.class.name }
end

describe Defaults do
  before do
    @donut = create_donut
    @new_donut = Donut.new
  end

  it "should set defaults" do
    @new_donut.flavor.should == "cream"
    @new_donut.name.should == "Cream"
    @new_donut.maker.should == "Dunkin Donuts"
    @new_donut.class_name.should == "Donut"
  end

  it "should set defaults only if attributes are blank" do
    @donut.flavor.should == "vanilla"
  end

  it "should return default value for an attribute" do
    @donut.default_for(:flavor).should == "cream"
  end

  it "should not set defaults" do
    Donut.first.flavor.should == "vanilla"
  end

  private
  def create_donut(options={})
    Donut.create({
      :flavor => "vanilla",
      :name => "Vanilla Sky",
      :maker => "Mr. Baker"
    }.merge(options))
  end
end
