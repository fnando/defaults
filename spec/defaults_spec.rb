# encoding: utf-8
require "spec_helper"

class Donut < ActiveRecord::Base
  attr_accessor :class_name

  defaults :flavor => "cream",
           :name => "Cream",
           :maker => proc { "Dunkin Donuts" },
           :class_name => lambda {|donut| donut.class.name }

  defaults :quantity => 5
end

describe Defaults do
  before do
    Donut.delete_all
    @donut = create_donut
    @new_donut = Donut.new
  end

  it "raises when invalid argument is provided" do
    expect {
      Donut.defaults nil
    }.to raise_error(ArgumentError)
  end

  it "sets default values" do
    @new_donut.flavor.should == "cream"
    @new_donut.name.should == "Cream"
    @new_donut.maker.should == "Dunkin Donuts"
    @new_donut.class_name.should == "Donut"
    @new_donut.quantity.should == 5
  end

  it "sets default values only when have blank attributes" do
    @donut.flavor.should == "vanilla"
    @donut.quantity.should == 5
  end

  it "returns default value for an attribute" do
    @donut.default_for(:flavor).should == "cream"
    @donut.default_for(:maker).should == "Dunkin Donuts"
    @donut.default_for(:class_name).should == "Donut"
    @donut.default_for(:quantity).should == 5
  end

  it "does not set default values" do
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
