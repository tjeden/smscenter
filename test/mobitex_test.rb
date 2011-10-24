require 'test/unit'
require 'webmock/test_unit'
require_relative '../lib/mobitex'

class MobitexTest < Test::Unit::TestCase
  def test_sms_delivery
    stub_request(:post, 'http://api.statsms.net/send.php')
    sms = Mobitex::Sms.new(number: '123456789', text: 'You ve got message')
    #assert_requested :post, 'http://api.statsms.net/send.php' do
      assert sms.deliver
    #end
  end
end
