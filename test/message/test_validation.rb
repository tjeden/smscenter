# -*- encoding: utf-8 -*-

require 'helper'

describe Mobitex::Message do

  describe '.errors' do
    describe 'for unvalidated message' do
      it 'returns empty Set' do
        Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'SpamNHam', :ext_id => '1').errors.must_equal Set.new
      end
    end

    describe 'for validated message' do
      describe 'with valid type, number, text, from and ext_id' do
        it 'returns true' do
          message = Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'SpamNHam', :ext_id => '1')

          message.valid?.must_equal true
          message.errors.must_equal Set.new
        end
      end

      describe 'with one invalid field' do
        it 'returns Set containing symbol of invalid field' do
          Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'message', :from => 'SpamNHam', :ext_id => '1').tap(&:valid?).errors.must_equal Set.new([:type])
          Mobitex::Message.new('+48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'SpamNHam', :ext_id => '1').tap(&:valid?).errors.must_equal Set.new([:number])
          Mobitex::Message.new('48123456789', '', :type => 'sms', :from => 'SpamNHam', :ext_id => '1').tap(&:valid?).errors.must_equal Set.new([:text])
          Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'VeryLongSender', :ext_id => '1').tap(&:valid?).errors.must_equal Set.new([:from])
          Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'SpamNHam', :ext_id => '1 and 2').tap(&:valid?).errors.must_equal Set.new([:ext_id])
        end
      end

      describe 'with multiple invalid fields' do
        it 'returns Set containing symbols of invalid fields' do
          Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'message', :from => 'SpamNHam', :ext_id => '1').tap(&:valid?).errors.must_equal Set.new([:type])
          Mobitex::Message.new('+48123456789', 'Egg, Bacon, Spam', :type => 'message', :from => 'SpamNHam', :ext_id => '1').tap(&:valid?).errors.must_equal Set.new([:type, :number])
          Mobitex::Message.new('+48123456789', '', :type => 'message', :from => 'message', :ext_id => '1').tap(&:valid?).errors.must_equal Set.new([:type, :number, :text])
          Mobitex::Message.new('+48123456789', '', :type => 'message', :from => 'VeryLongSender', :ext_id => '1').tap(&:valid?).errors.must_equal Set.new([:type, :number, :text, :from])
          Mobitex::Message.new('+48123456789', '', :type => 'message', :from => 'VeryLongSender', :ext_id => '1 and 2').tap(&:valid?).errors.must_equal Set.new([:type, :number, :text, :from, :ext_id])
        end
      end
    end
  end

  describe '.invalid?' do
    describe 'with valid message' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'SpamNHam', :ext_id => '1').invalid?.must_equal false
      end
    end

    describe 'with invalid message' do
      it 'returns true' do
        Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'SpamNHam', :ext_id => '1 and 2').invalid?.must_equal true
      end
    end
  end

  describe '.valid?' do
    describe 'with valid type, number, text, from and ext_id' do
      it 'returns true' do
        Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'SpamNHam', :ext_id => '1').valid?.must_equal true
      end
    end

    describe 'with invalid type, number, text, from or ext_id' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'message', :from => 'SpamNHam', :ext_id => '1').valid?.must_equal false
        Mobitex::Message.new('+48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'SpamNHam', :ext_id => '1').valid?.must_equal false
        Mobitex::Message.new('48123456789', '', :type => 'sms', :from => 'SpamNHam', :ext_id => '1').valid?.must_equal false
        Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'VeryLongSender', :ext_id => '1').valid?.must_equal false
        Mobitex::Message.new('48123456789', 'Egg, Bacon, Spam', :type => 'sms', :from => 'SpamNHam', :ext_id => '1 and 2').valid?.must_equal false
      end
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

    describe 'with comma-delimited list of 11-digit numbers' do
      it 'returns true' do
        Mobitex::Message.new('48123456789,11223344556', 'Text').number_valid?.must_equal true
        Mobitex::Message.new('48123456789,09876543210,11223344556', 'Text').number_valid?.must_equal true
        Mobitex::Message.new('48123456789,09876543210,11223344556,99887766554,10293847565', 'Text').number_valid?.must_equal true
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

    describe 'with comma-delimited list of 11-digit numbers containing invalid numbers' do
      it 'returns false' do
        Mobitex::Message.new('48123456789').number_valid?.must_equal true
        Mobitex::Message.new('48123456789,09876543210').number_valid?.must_equal true
        Mobitex::Message.new('48123456789,0987654321').number_valid?.must_equal false
        Mobitex::Message.new('48123456789,09876-543-210').number_valid?.must_equal false
      end
    end

    describe 'with comma-delimited 501-or-more-element list of 11-digit numbers' do
      it 'returns false' do
        numbers = ['48123456789', '09876543210', '11223344556', '99887766554', '10293847565'] * 100
        too_many_numbers = numbers + [numbers[0]]

        numbers.size.must_equal 500
        too_many_numbers.size.must_equal 501
        Mobitex::Message.new(numbers.join(','), 'Text').number_valid?.must_equal true
        Mobitex::Message.new(too_many_numbers.join(','), 'Text').number_valid?.must_equal false
      end
    end
  end

  describe '.text_valid?' do
    describe 'with empty text' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', '').text_valid?.must_equal false
      end
    end

    describe 'with blank text' do
      it 'returns false' do
        Mobitex::Message.new('48123456789', ' ').text_valid?.must_equal false
        Mobitex::Message.new('48123456789', "\t").text_valid?.must_equal false
        Mobitex::Message.new('48123456789', "\t \r \n \r\n \n\r").text_valid?.must_equal false
      end
    end

    describe 'for sms or sms_flash message' do
      describe 'with 160-or-less-character string' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', 'Really short message', :type => 'sms').text_valid?.must_equal true
          Mobitex::Message.new('48123456789', 'Really short message', :type => 'sms_flash').text_valid?.must_equal true
        end
      end

      describe 'with 160-or-less-character string containing double characters' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', '[Some] ~short ^text {containing} |double \\characters', :type => 'sms').text_valid?.must_equal true
          Mobitex::Message.new('48123456789', '[Some] ~short ^text {containing} |double \\characters', :type => 'sms_flash').text_valid?.must_equal true
        end
      end

      describe 'with 161-or-more-character string' do
        it 'returns false' do
          Mobitex::Message.new('48123456789', 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart.', :type => 'sms').text_valid?.must_equal false
          Mobitex::Message.new('48123456789', 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart.', :type => 'sms_flash').text_valid?.must_equal false
        end
      end

      describe 'with 160-character string containing double characters' do
        it 'returns false' do
          text = 'This text has length of 160 characters but it contains double symbols (like [, ], ~ or |) so it exceeds message maximum length and cannot be sent as normal sms.'

          text.length.must_equal 160
          Mobitex::Message.new('48123456789', text, :type => 'sms').text_valid?.must_equal false
          Mobitex::Message.new('48123456789', text, :type => 'sms_flash').text_valid?.must_equal false
        end
      end
    end

    describe 'for concat message' do
      describe 'with 459-or-less-character string' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart...', :type => 'concat').text_valid?.must_equal true
        end
      end

      describe 'with 459-or-less-character string containing double characters' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', '[Chocolate] ~cake ^marshmallow {icing} applicake|pudding \\marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet', :type => 'concat').text_valid?.must_equal true
        end
      end

      describe 'with 460-or-more-character string' do
        it 'returns false' do
          Mobitex::Message.new('48123456789', 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart... Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart...', :type => 'concat').text_valid?.must_equal false
        end
      end

      describe 'with 459-character string containing double characters' do
        it 'returns false' do
          text = 'This text has length of 459 characters but it contains double symbols (like [brackets], ~tilde, ^caret, {curly braces}, |pipe or \\backslash) so it exceeds message maximum length for concat message. Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki'

          text.length.must_equal 459
          Mobitex::Message.new('48123456789', text, :type => 'concat').text_valid?.must_equal false
        end
      end
    end

    describe 'for wap_push message' do
      describe 'with link and title' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', 'Link description|http://example.com/spam-n-ham').text_valid?.must_equal true
        end
      end

      describe 'with secure link and title' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', 'Link description|https://example.com/spam-n-ham').text_valid?.must_equal true
        end
      end

      describe 'with 225-or-less-character string' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', 'Chocolate cake marshmallow icing applicake pudding marzipan|http://Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate roll', :type => 'wap_push').text_valid?.must_equal true
        end
      end

      describe 'with 225-or-less-character string containing double characters' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', '[Chocolate] ~cake ^marshmallow {icing} applicake|http://pudding \\marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake.', :type => 'wap_push').text_valid?.must_equal true
        end
      end

      describe 'with link without title' do
        it 'returns false' do
          Mobitex::Message.new('48123456789', 'http://example.com/no-title', :type => 'wap_push').text_valid?.must_equal false
        end
      end

      describe 'with title and no link' do
        it 'returns false' do
          Mobitex::Message.new('48123456789', 'Link description', :type => 'wap_push').text_valid?.must_equal false
        end
      end

      describe 'with broken link' do
        it 'returns false' do
          Mobitex::Message.new('48123456789', 'Link description|ftp://example.com', :type => 'wap_push').text_valid?.must_equal false
        end
      end

      describe 'with 226-or-more-character string' do
        it 'returns false' do
          Mobitex::Message.new('48123456789', 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart... Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart...', :type => 'wap_push').text_valid?.must_equal false
        end
      end

      describe 'with 225-character string containing double characters' do
        it 'returns false' do
          text = 'This text has length of 225 characters but it contains double symbols (like [brackets], ~tilde, ^caret, {curly braces}, |pipe or \\backslash) so it exceeds message maximum length for concat message. Chocolate cake marshmallow.'

          text.length.must_equal 225
          Mobitex::Message.new('48123456789', text, :type => 'wap_push').text_valid?.must_equal false
        end
      end
    end

    describe 'for binary message' do
      describe 'with 280-or-less-character string' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle..', :type => 'binary').text_valid?.must_equal true
        end
      end

      describe 'with 280-or-less-character string containing double characters' do
        it 'returns true' do
          Mobitex::Message.new('48123456789', '[Chocolate] ~cake ^marshmallow {icing} applicake|pudding \\marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki....', :type => 'binary').text_valid?.must_equal true
        end
      end

      describe 'with 281-or-more-character string' do
        it 'returns false' do
          Mobitex::Message.new('48123456789', 'Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart... Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake applicake. Carrot cake donut jelly tart carrot cake sweet roll donut tootsie roll chupa chups jelly. Chocolate candy fruitcake chocolate jujubes ice cream chocolate. Tart halvah faworki tiramisu souffle tiramisu jelly marshmallow. Toffee donut chupa chups powder souffle gingerbread jelly-o wafer chocolate cake. Cake wafer caramels chupa chups jelly carrot cake sweet powder tart...', :type => 'binary').text_valid?.must_equal false
        end
      end

      describe 'with 280-character string containing double characters' do
        it 'returns false' do
          text = 'This text has length of 280 characters but it contains double symbols (like [brackets], ~tilde, ^caret, {curly braces}, |pipe or \\backslash) so it exceeds message maximum length for concat message. Chocolate cake marshmallow icing applicake pudding marzipan. Powder cupcake carrot'

          text.length.must_equal 280
          Mobitex::Message.new('48123456789', text, :type => 'binary').text_valid?.must_equal false
        end
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
        Mobitex::Message.new('48123456789', 'Text', :ext_id => '$Some!{More}<Sophisticated>(_Id_)-[12345]').ext_id_valid?.must_equal true
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