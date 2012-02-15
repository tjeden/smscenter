require 'helper'

describe Mobitex::Message do

  describe '.type' do
    it 'returns the type calculated from text length' do
      short_message = Mobitex::Message.new('48123456789', 'Short message')
      long_message  = Mobitex::Message.new('48123456789', 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart.')

      short_message.type.must_equal 'sms'
      long_message.type.must_equal  'concat'
    end
  end

  describe '.length' do
    it 'returns length of the text with double characters' do
      single_characters = 'Short message'
      double_characters = '[square brackets] ~tilde ^caret {curly braces} |pipe \\backslash'

      assert single_characters.length.must_equal 13
      assert Mobitex::Message.new('48123456789', single_characters).length.must_equal 13

      assert double_characters.length.must_equal 63
      assert Mobitex::Message.new('48123456789', double_characters).length.must_equal 71
    end
  end

  describe '.from' do
    it 'returns sanitized from field' do
      assert Mobitex::Message.new('48123456789', 'Text', :from => 4812345678901234567890).from.must_equal '4812345678901234'
      assert Mobitex::Message.new('48123456789', 'Text', :from => '4812345678901234567890').from.must_equal '4812345678901234'
      assert Mobitex::Message.new('48123456789', 'Text', :from => 'Egg, Bacon, Spam, Baked Beans, Spam, Sausage and Spam').from.must_equal 'Egg, Bacon,'
    end
  end

  describe '.to_params' do
    it 'returns Hash representation of the object' do
      message = Mobitex::Message.new('481234567890', 'No big deal', :from => 'Me to you', :ext_id => '123')
      params  = message.to_params

      assert params[:number].must_equal '481234567890'
      assert params[:text].must_equal   'No big deal'
      assert params[:from].must_equal   'Me to you'
      assert params[:ext_id].must_equal '123'
    end
  end

end