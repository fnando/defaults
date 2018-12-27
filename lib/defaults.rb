module Defaults
  require "defaults/version"

  def self.execute_callable(value, record)
    callable = value.is_a?(Proc) ? value : value.method(:call)
    callable.arity == 1 ? value.call(record) : value.call
  end

  def self.default_value_for_column(model, attribute)
    column_info = model.columns_hash[attribute.to_s]
    ActiveRecord::Type.lookup(column_info.type).cast(column_info.default) if column_info
  end

  def self.default_value(model, record, attribute)
    value = model.default_values[attribute]
    value = Defaults.execute_callable(value, record) if value.respond_to?(:call)
    value
  end

  def self.resolve_default_value(model, record, attribute)
    attribute = attribute.to_sym

    # Check if value has been defined by `defaults`.
    # If it is, try to resolve by checking if value is callable.
    # Otherwise returns the default value of that column.
    if model.default_values.key?(attribute)
      Defaults.default_value(model, record, attribute)
    else
      Defaults.default_value_for_column(model, attribute)
    end
  end

  def self.included(base)
    base.extend ClassMethods

    class << base
      attr_accessor :default_values
    end
  end

  module ClassMethods
    def defaults(attrs)
      raise ArgumentError, "Hash expected; #{attrs.class} given." unless attrs.is_a?(Hash)

      include InstanceMethods

      self.default_values ||= {}
      self.default_values.merge!(attrs)

      after_initialize :set_default_attributes
    end
  end

  module InstanceMethods
    def default_for(name)
      Defaults.resolve_default_value(self.class, self, name)
    end

    private def set_default_attributes
      return unless new_record?

      self.class.default_values.keys.each do |name|
        value = read_attribute(name) if changes[name]
        value = default_for(name) if value.blank?

        public_send "#{name}=", value
      end
    end
  end
end

ActiveRecord::Base.send(:include, Defaults)
