$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'test/unit'
require 'webmock/test_unit'
require 'mobitex'

class MobitexTest < Test::Unit::TestCase
  def assert_sms_send(text, options = {})
    options[:number] ||= '48123456789'
    text.gsub!(/ /,'\\\\+')
    
    regexp = "number=#{options[:number]}&text=#{text}"
    assert_requested(:post, "http://api.statsms.net/send.php", :times => 1) do |req| 
      req.body =~ Regexp.new(regexp) && req.body =~ /type=sms/ && req.body =~ /pass=faked/ && req.body =~/user=faked/
    end
  end

  def test_sms_delivery
    WebMock.reset!
    WebMock.disable_net_connect!
    stub_request(:post, "http://api.statsms.net/send.php").
      with( :headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => "Status: 002, Id: 03a72a49fb9595f3737bc4a2519ff283, Number: 4860X123456", :headers => {})

    outbox = Mobitex::Outbox.new('faked', 'faked')
    outbox.deliver_sms('48123456789', 'you have got mail')

    assert_sms_send('you have got mail')
  end
end
