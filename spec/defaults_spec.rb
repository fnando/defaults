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
    expect(@new_donut.flavor).to eq("cream")
    expect(@new_donut.name).to eq("Cream")
    expect(@new_donut.maker).to eq("Dunkin Donuts")
    expect(@new_donut.class_name).to eq("Donut")
    expect(@new_donut.quantity).to eq(5)
  end

  it "sets default values only when have blank attributes" do
    expect(@donut.flavor).to eq("vanilla")
    expect(@donut.quantity).to eq(5)
  end

  it "returns default value for an attribute" do
    expect(@donut.default_for(:flavor)).to eq("cream")
    expect(@donut.default_for(:maker)).to eq("Dunkin Donuts")
    expect(@donut.default_for(:class_name)).to eq("Donut")
    expect(@donut.default_for(:quantity)).to eq(5)
  end

  it "does not set default values" do
    expect(Donut.first.flavor).to eq("vanilla")
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
