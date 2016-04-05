require "test_helper"

class Donut < ActiveRecord::Base
  attr_accessor :class_name

  defaults flavor: "cream",
           name: "Cream",
           maker: proc { "Dunkin Donuts" },
           class_name: -> donut { donut.class.name }

  defaults quantity: 5
  defaults available: false
end

class DefaultsTest < Minitest::Test
  let(:donut) { create_donut }
  let(:new_donut) { Donut.new }

  setup do
    Donut.delete_all
  end

  test "considers detabase defaults with type casting" do
    assert_equal 0.00, new_donut.default_for(:price)
  end

  test "has precedence over database defaults" do
    refute new_donut.available?
  end

  test "raises when invalid argument is provided" do
    assert_raises(ArgumentError) { Donut.defaults nil }
  end

  test "sets default values" do
    assert_equal "cream", new_donut.flavor
    assert_equal "Cream", new_donut.name
    assert_equal "Dunkin Donuts", new_donut.maker
    assert_equal "Donut", new_donut.class_name
    assert_equal 5, new_donut.quantity
  end

  test "sets default values only when have blank attributes" do
    assert_equal "vanilla", donut.flavor
    assert_equal 5, donut.quantity
  end

  test "returns default value for an attribute" do
    assert_equal "cream", donut.default_for(:flavor)
    assert_equal "Dunkin Donuts", donut.default_for(:maker)
    assert_equal "Donut", donut.default_for(:class_name)
    assert_equal 5, donut.default_for(:quantity)
  end

  test "does not set default values" do
    assert_equal donut, Donut.first
    assert_equal "vanilla", Donut.first.flavor
  end

  private

  def create_donut(options = {})
    Donut.create({
      flavor: "vanilla",
      name: "Vanilla Sky",
      maker: "Mr. Baker"
    }.merge(options))
  end
end
