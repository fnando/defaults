module Defaults
  require 'defaults/version'

  def self.included(base)
    base.extend ClassMethods

    class << base
      attr_accessor :default_options
    end
  end

  module ClassMethods
    # defaults :title => "Add your title here"
    def defaults(attrs)
      raise ArgumentError, "Hash expected; #{attrs.class} given." unless attrs.kind_of?(Hash)

      include InstanceMethods

      self.default_options ||= {}
      self.default_options.merge!(attrs)

      after_initialize :set_default_attributes
    end
  end

  module InstanceMethods
    def default_for(name)
      if self.class.default_options.key?(name.to_sym)
        value = self.class.default_options[name.to_sym]
        value = value.arity == 1 ? value.call(self) : value.call if value.respond_to?(:call)
      else
        column_info = self.class.columns_hash[name.to_s]
        value = column_info.type_cast_from_user(column_info.default) if column_info
      end

      value
    end

    private
    def set_default_attributes
      return unless new_record?

      self.class.default_options.keys.each do |name|
        value = read_attribute(name) if changes[name]
        value = default_for(name) if value.blank?

        __send__ "#{name}=", value
      end
    end
  end
end

ActiveRecord::Base.send(:include, Defaults)
