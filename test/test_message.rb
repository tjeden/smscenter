# -*- encoding: utf-8 -*-

require 'helper'

describe Mobitex::Message do

  describe '::type_valid?' do
    describe 'with supported message types' do
      it 'returns true' do
        Mobitex::Message.type_valid?('sms').must_equal true
        Mobitex::Message.type_valid?('concat').must_equal true
        Mobitex::Message.type_valid?('sms_flash').must_equal true
        Mobitex::Message.type_valid?('wap_push').must_equal true
        Mobitex::Message.type_valid?('binary').must_equal true
      end
    end

    describe 'with unsupported message types' do
      it 'returns false' do
        Mobitex::Message.type_valid?('long_sms').must_equal false
        Mobitex::Message.type_valid?('message').must_equal false
        Mobitex::Message.type_valid?('flash').must_equal false
      end
    end
  end

  describe '::number_valid?' do
    describe 'with 11-digit number' do
      it 'returns true' do
        Mobitex::Message.number_valid?('48123456789').must_equal true
        Mobitex::Message.number_valid?('09876543210').must_equal true
        Mobitex::Message.number_valid?('11223344556').must_equal true
      end
    end

    describe 'with number not containing country code' do
      it 'returns false' do
        Mobitex::Message.number_valid?('123456789').must_equal false
        Mobitex::Message.number_valid?('876543210').must_equal false
        Mobitex::Message.number_valid?('223344556').must_equal false
      end
    end

    describe 'with number containing non-digit symbols' do
      it 'returns false' do
        Mobitex::Message.number_valid?('48 123 456 789').must_equal false
        Mobitex::Message.number_valid?('09 876-54-32-10').must_equal false
        Mobitex::Message.number_valid?('(11) 223344556').must_equal false
      end
    end
  end

  describe '::from_valid?' do
    describe 'with 16-or-less-digit number' do
      it 'returns true' do
        Mobitex::Message.from_valid?('1234567890123456').must_equal true
        Mobitex::Message.from_valid?('12345').must_equal true
        Mobitex::Message.from_valid?('1').must_equal true
      end
    end

    describe 'with 11-or-less-character alphanumeric string' do
      it 'returns true' do
        Mobitex::Message.from_valid?('OnlyLetters').must_equal true
        Mobitex::Message.from_valid?('S0m3D1g1t5').must_equal true
        Mobitex::Message.from_valid?('AtoZ0to9').must_equal true
      end
    end

    describe 'with empty string' do
      it 'returns false' do
        Mobitex::Message.from_valid?('').must_equal false
      end
    end

    describe 'with 17-or-more-digit number' do
      it 'returns false' do
        Mobitex::Message.from_valid?('12345678901234567').must_equal false
        Mobitex::Message.from_valid?('1234567890123456789012345678901234567890').must_equal false
      end
    end

    describe 'with 12-or-more-character alphanumeric string' do
      it 'returns false' do
        Mobitex::Message.from_valid?('TooManyWords').must_equal false
        Mobitex::Message.from_valid?('123MuchTooLongTextWithSomeDigitsInIt').must_equal false
      end
    end

    describe 'with string containing non-literal characters' do
      it 'returns false' do
        Mobitex::Message.from_valid?('One space').must_equal false
        Mobitex::Message.from_valid?('Dash-dash').must_equal false
      end
    end

    describe 'with string containing non-latin characters' do
      it 'returns false' do
        Mobitex::Message.from_valid?('Zażółć').must_equal false
      end
    end
  end

  describe '::ext_id_valid?' do
    describe 'with empty string' do
      it 'returns true' do
        Mobitex::Message.ext_id_valid?('').must_equal true
      end
    end

    describe 'with 50-or-less-character string' do
      it 'returns true' do
        Mobitex::Message.ext_id_valid?('SomeId').must_equal true
        Mobitex::Message.ext_id_valid?('Some{More}Sophisticated(Id)[12345]').must_equal true
      end
    end

    describe 'with 51-or-more-character string' do
      it 'returns false' do
        Mobitex::Message.ext_id_valid?('123456789012345678901234567890123456789012345678901').must_equal false
      end
    end

    describe 'with blank string' do
      it 'returns false' do
        Mobitex::Message.ext_id_valid?(' ').must_equal false
        Mobitex::Message.ext_id_valid?("\t").must_equal false
      end
    end

    describe 'with string containing non-latin characters' do
      it 'returns false' do
        Mobitex::Message.ext_id_valid?('Gęśla').must_equal false
      end
    end
  end

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