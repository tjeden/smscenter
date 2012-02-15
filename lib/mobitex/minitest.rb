require 'minitest/unit'
require 'mobitex/test_helpers'

MiniTest::Unit::TestCase.class_eval do
  include Mobitex::TestHelpers
end
