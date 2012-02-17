# -*- encoding: utf-8 -*-

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
      assert Mobitex::Message.new('48123456789', 'Text', :from => 4812345678901234567890).sanitized_from.must_equal '4812345678901234'
      assert Mobitex::Message.new('48123456789', 'Text', :from => '4812345678901234567890').sanitized_from.must_equal '4812345678901234'
      assert Mobitex::Message.new('48123456789', 'Text', :from => 'Egg, Bacon, Spam, Baked Beans, Spam, Sausage and Spam').sanitized_from.must_equal 'Egg, Bacon,'
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

  describe '.type_valid?' do
    describe 'with supported message types' do
      it 'returns true' do
        Mobitex::Message.new('48123456789', 'Text', :type => 'sms').type_valid?.must_equal true
        Mobitex::Message.new('48123456789', 'Text', :type => 'concat').type_valid?.must_equal true
        Mobitex::Message.new('48123456789', 'Text', :type => 'sms_flash').type_valid?.must_equal true
        Mobitex::Message.new('48123456789', 'Text', :type => 'wap_push').type_valid?.must_equal true
        Mobitex::Message.new('48123456789', 'Text', :type => 'binary').type_valid?.must_equal true
      end
    end

    describe 'with unsupported message types' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Text', :type => 'long_sms').type_valid?.must_equal false
        Mobitex::Message.new('48123456789', 'Text', :type => 'message').type_valid?.must_equal false
        Mobitex::Message.new('48123456789', 'Text', :type => 'flash').type_valid?.must_equal false
      end
    end
  end

  describe '.number_valid?' do
    describe 'with 11-digit number' do
      it 'returns true' do
        Mobitex::Message.new('48123456789', 'Text').number_valid?.must_equal true
        Mobitex::Message.new('09876543210', 'Text').number_valid?.must_equal true
        Mobitex::Message.new('11223344556', 'Text').number_valid?.must_equal true
      end
    end

    describe 'with number not containing country code' do
      it 'returns false' do
        Mobitex::Message.new('123456789', 'Text').number_valid?.must_equal false
        Mobitex::Message.new('876543210', 'Text').number_valid?.must_equal false
        Mobitex::Message.new('223344556', 'Text').number_valid?.must_equal false
      end
    end

    describe 'with number containing non-digit symbols' do
      it 'returns false' do
        Mobitex::Message.new('48 123 456 789', 'Text').number_valid?.must_equal false
        Mobitex::Message.new('09 876-54-32-10', 'Text').number_valid?.must_equal false
        Mobitex::Message.new('(11) 223344556', 'Text').number_valid?.must_equal false
      end
    end
  end

  describe '.from_valid?' do
    describe 'with 16-or-less-digit number' do
      it 'returns true' do
        Mobitex::Message.new('48123456789', 'Text', :from => '1234567890123456').from_valid?.must_equal true
        Mobitex::Message.new('48123456789', 'Text', :from => '12345').from_valid?.must_equal true
        Mobitex::Message.new('48123456789', 'Text', :from => '1').from_valid?.must_equal true
      end
    end

    describe 'with 11-or-less-character alphanumeric string' do
      it 'returns true' do
        Mobitex::Message.new('48123456789', 'Text', :from => 'OnlyLetters').from_valid?.must_equal true
        Mobitex::Message.new('48123456789', 'Text', :from => 'S0m3D1g1t5').from_valid?.must_equal true
        Mobitex::Message.new('48123456789', 'Text', :from => 'AtoZ0to9').from_valid?.must_equal true
      end
    end

    describe 'with empty string' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Text', :from => '').from_valid?.must_equal false
      end
    end

    describe 'with 17-or-more-digit number' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Text', :from => '12345678901234567').from_valid?.must_equal false
        Mobitex::Message.new('48123456789', 'Text', :from => '1234567890123456789012345678901234567890').from_valid?.must_equal false
      end
    end

    describe 'with 12-or-more-character alphanumeric string' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Text', :from => 'TooManyWords').from_valid?.must_equal false
        Mobitex::Message.new('48123456789', 'Text', :from => '123MuchTooLongTextWithSomeDigitsInIt').from_valid?.must_equal false
      end
    end

    describe 'with string containing non-literal characters' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Text', :from => 'One space').from_valid?.must_equal false
        Mobitex::Message.new('48123456789', 'Text', :from => 'Dash-dash').from_valid?.must_equal false
      end
    end

    describe 'with string containing non-latin characters' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Text', :from => 'Zażółć').from_valid?.must_equal false
      end
    end
  end

  describe '.ext_id_valid?' do
    describe 'with empty string' do
      it 'returns true' do
        Mobitex::Message.new('48123456789', 'Text', :ext_id => '').ext_id_valid?.must_equal true
      end
    end

    describe 'with 50-or-less-character string' do
      it 'returns true' do
        Mobitex::Message.new('48123456789', 'Text', :ext_id => 'SomeId').ext_id_valid?.must_equal true
        Mobitex::Message.new('48123456789', 'Text', :ext_id => 'Some{More}Sophisticated(Id)[12345]').ext_id_valid?.must_equal true
      end
    end

    describe 'with 51-or-more-character string' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Text', :ext_id => '123456789012345678901234567890123456789012345678901').ext_id_valid?.must_equal false
      end
    end

    describe 'with blank string' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Text', :ext_id => ' ').ext_id_valid?.must_equal false
        Mobitex::Message.new('48123456789', 'Text', :ext_id => "\t").ext_id_valid?.must_equal false
      end
    end

    describe 'with string containing non-latin characters' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Text', :ext_id => 'Gęśla').ext_id_valid?.must_equal false
      end
    end
  end

end