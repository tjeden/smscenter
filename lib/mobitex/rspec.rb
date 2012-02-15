require 'mobitex/test_helpers'

# RSpec 1.x and 2.x compatibility
if defined?(RSpec) && defined?(RSpec::Expectations)
  RSPEC_CONFIGURER = RSpec
elsif defined?(Spec)
  RSPEC_CONFIGURER = Spec::Runner
else
  begin
    require 'rspec/core'
    require 'rspec/expectations'
    RSPEC_CONFIGURER = RSpec
  rescue LoadError
    require 'spec'
    RSPEC_CONFIGURER = Spec::Runner
  end
end

RSPEC_CONFIGURER.configure{ |config| config.include Mobitex::TestHelpers }
