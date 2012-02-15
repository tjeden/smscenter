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

    it 'delivers long text' do
      text = 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart.'

      assert_delivered text, {:type => 'concat'} do
        @outbox.deliver('48123456789', text)
      end
    end

  end

end