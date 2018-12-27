module Defaults
  require "defaults/version"

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
      # Check if value has been defined by `defaults`.
      # If it is, try to resolve by checking if value is callable.
      # Otherwise returns the default value of that column.
      if self.class.default_values.key?(name.to_sym)
        value = self.class.default_values[name.to_sym]

        if value.respond_to?(:call)
          callable = value.is_a?(Proc) ? value : value.method(:call)
          value = callable.arity == 1 ? value.call(self) : value.call
        end
      else
        column_info = self.class.columns_hash[name.to_s]
        value = ActiveRecord::Type.lookup(column_info.type).cast(column_info.default) if column_info
      end

      value
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
