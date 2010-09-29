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

      self.default_options = attrs
      after_initialize :set_default_attributes
    end

    def has_defaults(attrs)
      warn "[WARNING] Using has_defaults is now deprecated. Please use defaults instead."
      defaults(attrs)
    end
  end

  module InstanceMethods
    def default_for(name)
      self.class.default_options[name.to_sym]
    end

    private
    def set_default_attributes
      if new_record?
        self.class.default_options.each do |name, value|
          value = value.arity == 1 ? value.call(self) : value.call if value.respond_to?(:call)
          send("#{name}=", value) if send(name).blank?
        end
      end
    end
  end
end

# ActiveRecord only calls after_initialize callbacks only if is
# explicit defined in a class.
if ActiveRecord::VERSION::STRING < "3.0"
  class ActiveRecord::Base; def after_initialize; end; end
end

ActiveRecord::Base.send(:include, Defaults)
