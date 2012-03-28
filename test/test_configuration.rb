require 'helper'

class CustomDelivery
  attr_accessor :settings

  def initialize(values)
    @settings = {}.merge!(values)
  end
end

describe Mobitex do

  before do
    Mobitex::Configuration.instance.send(:reset!)
  end

  describe '#defaults' do

    it 'configures HTTP as default delivery method' do
      Mobitex.delivery_method.class.must_equal Mobitex::HTTPDelivery
      Mobitex.delivery_method.settings[:user].must_be_nil
      Mobitex.delivery_method.settings[:pass].must_be_nil
    end

    describe 'with DSL configuration block' do

      it 'configures HTTP delivery' do
        Mobitex.configure do
          delivery_method :http, {
              :user => 'john',
              :pass => 'doe'
          }
        end

        Mobitex.delivery_method.class.must_equal Mobitex::HTTPDelivery
        Mobitex.delivery_method.settings[:user].must_equal 'john'
        Mobitex.delivery_method.settings[:pass].must_equal 'doe'
      end

      it 'configures File delivery' do
        Mobitex.configure{ delivery_method :file, {:location => './my_tmp'} }

        Mobitex.delivery_method.class.must_equal Mobitex::FileDelivery
        Mobitex.delivery_method.settings[:location].must_equal './my_tmp'
      end

      it 'configures Test delivery' do
        Mobitex.configure{ delivery_method :test }

        Mobitex.delivery_method.class.must_equal Mobitex::TestDelivery
      end

      it 'configures custom delivery' do
        Mobitex.configure{ delivery_method CustomDelivery, {:option1 => 'value1', :option2 => 'value2'} }

        Mobitex.delivery_method.class.must_equal CustomDelivery
        Mobitex.delivery_method.settings[:option1].must_equal 'value1'
        Mobitex.delivery_method.settings[:option2].must_equal 'value2'
      end

    end

    describe 'with configuration block' do

      it 'configures HTTP delivery' do
        Mobitex.configure do |config|
          config.delivery_method :http, {
              :user => 'jack',
              :pass => 'daniels'
          }
        end

        Mobitex.delivery_method.class.must_equal Mobitex::HTTPDelivery
        Mobitex.delivery_method.settings[:user].must_equal 'jack'
        Mobitex.delivery_method.settings[:pass].must_equal 'daniels'
      end

      it 'configures File delivery' do
        Mobitex.configure{ |config| config.delivery_method :file, {:location => './my_new_tmp'} }

        Mobitex.delivery_method.class.must_equal Mobitex::FileDelivery
        Mobitex.delivery_method.settings[:location].must_equal './my_new_tmp'
      end

      it 'configures Test delivery' do
        Mobitex.configure{ |config| config.delivery_method :test }

        Mobitex.delivery_method.class.must_equal Mobitex::TestDelivery
      end

      it 'configures custom delivery' do
        Mobitex.configure{ |config| config.delivery_method CustomDelivery, {:new_option1 => 'new_value1', :new_option2 => 'new_value2'} }

        Mobitex.delivery_method.class.must_equal CustomDelivery
        Mobitex.delivery_method.settings[:new_option1].must_equal 'new_value1'
        Mobitex.delivery_method.settings[:new_option2].must_equal 'new_value2'
      end

    end

  end

end
