require 'minitest/unit'
require 'mobitex'

MiniTest::Unit::TestCase.class_eval do
  include Mobitex::TestHelpers
end
