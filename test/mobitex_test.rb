$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'test/unit'
require 'webmock/test_unit'
require 'mobitex'

class MobitexTest < Test::Unit::TestCase
  def setup
    WebMock.reset!
    WebMock.disable_net_connect!
  end

  def assert_sms_send(text, options = {})
    options[:number] ||= '48123456789'
    options[:type]   ||= 'sms'
    text.gsub!(/ /,'\\\\+')
    
    number  = Regexp.new("number=#{options[:number]}")
    content = Regexp.new("text=#{text}")
    type    = Regexp.new("type=#{options[:type]}")

    assert_requested(:post, "http://api.statsms.net/send.php", :times => 1) do |req| 
      req.body =~ number && req.body =~ type && req.body =~ content && req.body =~ /pass=faked/ && req.body =~/user=faked/
    end
  end

  def test_sms_delivery
    stub_request(:post, "http://api.statsms.net/send.php").
      with( :headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => "Status: 002, Id: 03a72a49fb9595f3737bc4a2519ff283, Number: 4860X123456", :headers => {})

    outbox = Mobitex::Outbox.new('faked', 'faked')
    outbox.deliver_sms('48123456789', 'you have got mail')

    assert_sms_send('you have got mail')
  end

  def test_longer_sms
    text = 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart.'
    stub_request(:post, "http://api.statsms.net/send.php").
      with( :headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => "Status: 002, Id: 03a72a49fb9595f3737bc4a2519ff283, Number: 4860X123456", :headers => {})

    outbox = Mobitex::Outbox.new('faked', 'faked')
    outbox.deliver_sms('48123456789', text)

    assert_sms_send(text, :type => 'concat')
  end
end
