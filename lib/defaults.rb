module Defaults
  autoload :Version, "defaults/version"

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
      value = self.class.default_options[name.to_sym]
      value = value.arity == 1 ? value.call(self) : value.call if value.respond_to?(:call)
      value
    end

    private
    def set_default_attributes
      if new_record?
        self.class.default_options.keys.each do |name|
          # First, retrieve default value set through database.
          # Will use this value in order to detect if value should be set.
          info = self.class.columns_hash[name.to_s]
          database_default = info ? info.default : nil

          value = read_attribute(name)
          __send__ "#{name}=", default_for(name) if value.blank? || value == database_default
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Defaults)
