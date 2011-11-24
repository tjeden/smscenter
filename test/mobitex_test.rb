require 'test/unit'
require 'webmock/test_unit'
require_relative '../lib/mobitex'
class MobitexTest < Test::Unit::TestCase
  def assert_sms_send(text, options = {})
    options[:number] ||= '48123456789'
    text.gsub!(/ /,'+')

    assert_requested :post, "http://api.statsms.net/send.php", body: "user=faked&pass=faked&number=#{options[:number]}&text=#{text}&from=SMS+Service&type=sms", headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}
  end

  def test_sms_delivery
    WebMock.reset!
    WebMock.disable_net_connect!
    stub_request(:post, "http://api.statsms.net/send.php").
      with(:body => "user=faked&pass=faked&number=48123456789&text=you+have+got+mail&from=SMS+Service&type=sms",
           :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "Status: 002, Id: 03a72a49fb9595f3737bc4a2519ff283, Number: 4860X123456", :headers => {})

    outbox = Mobitex::Outbox.new('faked', 'faked')
    outbox.deliver_sms('48123456789', 'you have got mail')

    assert_sms_send('you have got mail')
  end
end
