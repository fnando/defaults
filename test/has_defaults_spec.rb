require "spec_helper"

# unset models used for testing purposes
Object.unset_class('Donut')

class Donut < ActiveRecord::Base
  has_defaults :flavor => "cream", :name => "Cream", :maker => "Dunkin Donuts"
end

describe "has_defaults" do
  before(:each) do
    @donut = create_donut
    @new_donut = Donut.new
  end
  
  it "should set defaults" do
    @new_donut.flavor.should == "cream"
    @new_donut.name.should == "Cream"
    @new_donut.maker.should == "Dunkin Donuts"
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
      Donut.create({:flavor => "vanilla", :name => "Vanilla Sky", :maker => "Mr. Baker"}.merge(options))
    end
end