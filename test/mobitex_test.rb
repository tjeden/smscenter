$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'test/unit'
require 'webmock/test_unit'
require 'mobitex'

class MobitexTest < Test::Unit::TestCase
  include Mobitex::TestHelpers

  def setup
    super
  end
  def test_sms_delivery
    outbox = Mobitex::Outbox.new(:api_user => 'faked', :api_pass => 'faked')
    outbox.deliver_sms('48123456789', 'you have got mail')

    assert_sms_send('you have got mail')
  end

  def test_longer_sms
    text = 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart.'

    outbox = Mobitex::Outbox.new(:api_user => 'faked', :api_pass => 'faked')
    outbox.deliver_sms('48123456789', text)

    assert_sms_send(text, :type => 'concat')
  end

end
