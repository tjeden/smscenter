require 'helper'

describe Mobitex::Outbox do

  describe 'when sending a message' do

    before do
      WebMock.reset!
      WebMock.disable_net_connect!

      @outbox = Mobitex::Outbox.new(:api_user => 'faked', :api_pass => 'faked')
    end

    it 'delivers short text' do
      assert_delivered 'I want to play a game' do
        @outbox.deliver('48123456789', 'I want to play a game')
      end
    end

    it 'delivers long text as "concat"' do
      text = 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart.'

      assert_delivered text, {:type => 'concat'} do
        @outbox.deliver('48123456789', text)
      end
    end

    it 'counts special characters as double symbols' do
      text = 'Some [characters] are treated as {double|symbols}, so even if a ~message length in ^Ruby is 160,\\ it will be sent as "concat" by gateway and take up more space.'

      text.length.must_equal 160
      assert_delivered text, {:type => 'concat'} do
        @outbox.deliver('48123456789', text)
      end
    end

    it 'limits "from" field to 16 digits if it is a number' do
      from = 48123456789012345678

      assert from.to_s.length > 16
      assert_delivered 'From me to you', {:from => '4812345678901234'} do
        @outbox.deliver('48123456789', 'From me to you', :from => from)
      end
    end

    it 'limits "from" field to 16 characters if it looks like a number' do
      from = '48123456789012345678'

      assert from.length > 16
      assert_delivered 'From me to you', {:from => '4812345678901234'} do
        @outbox.deliver('48123456789', 'From me to you', :from => from)
      end
    end

    it 'limits "from" field to 11 characters if it is alphanumeric' do
      from = 'Spam bacon sausage and spam'

      assert from.length > 11
      assert_delivered 'From me to you', {:from => 'Spam bacon '} do
        @outbox.deliver('48123456789', 'From me to you', :from => from)
      end
    end

  end

end
