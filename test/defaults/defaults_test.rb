require "test_helper"

class Donut < ActiveRecord::Base
  attr_accessor :class_name

  slug_generator = Class.new do
    def self.call
      "delicious-donut-#{(1000..9999).to_a.sample}"
    end
  end

  defaults flavor: "cream",
           name: "Cream",
           maker: proc { "Dunkin Donuts" },
           class_name: ->(donut) { donut.class.name },
           slug: slug_generator

  defaults quantity: 5
  defaults available: false
end

class DefaultsTest < Minitest::Test
  let(:donut) { create_donut }
  let(:new_donut) { Donut.new }

  setup do
    Donut.delete_all
  end

  test "considers database defaults with type casting" do
    assert_kind_of Float, new_donut.default_for(:price)
    assert_equal 0.00, new_donut.default_for(:price)
  end

  test "has precedence over database defaults" do
    assert ActiveRecord::Type.lookup(:boolean).cast(Donut.columns_hash["available"].default)
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
    assert_match /^delicious-donut-\d{4}$/, new_donut.slug
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

  test "considers arity=0 of callable (lambda)" do
    donut_class = model do
      defaults quantity: -> { 1234 }
    end

    donut = donut_class.new

    assert_equal 1234, donut.default_for(:quantity)
  end

  test "considers arity=1 of callable (lambda)" do
    record = nil

    donut_class = model do
      defaults quantity: ->(r) { record = r }
    end

    donut = donut_class.new
    donut.default_for(:quantity)

    assert_equal donut, record
  end

  test "considers arity=0 of callable (class)" do
    quantity_class = Class.new do
      def self.call
        1234
      end
    end

    donut_class = model do
      defaults quantity: quantity_class
    end

    donut = donut_class.new

    assert_equal 1234, donut.default_for(:quantity)
  end

  test "considers arity=1 of callable (class)" do
    quantity_class = Class.new do
      def self.record
        @record
      end

      def self.call(record)
        @record = record
      end
    end

    donut_class = model do
      defaults quantity: quantity_class
    end

    donut = donut_class.new
    donut.default_for(:quantity)

    assert_equal donut, quantity_class.record
  end

  test "overrides default values" do
    donut_class = model do
      defaults quantity: -> { 1234 }
    end

    donut_class.default_values[:quantity] = 42

    donut = donut_class.new

    assert_equal 42, donut.default_for(:quantity)
  end

  private

  def model(&block)
    Class.new(ActiveRecord::Base) do
      self.table_name = :donuts
      instance_eval(&block)
    end
  end

  def create_donut(options = {}, model = Donut)
    model.create({
      flavor: "vanilla",
      name: "Vanilla Sky",
      maker: "Mr. Baker"
    }.merge(options))
  end
end
