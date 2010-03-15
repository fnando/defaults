require "has_defaults"

# ActiveRecord only calls after_initialize callbacks only if is
# explicit defined in a class.
if ActiveRecord::VERSION::STRING < "3.0"
  class ActiveRecord::Base; def after_initialize; end; end
end

ActiveRecord::Base.send(:include, SimplesIdeias::Acts::Defaults)