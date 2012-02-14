require 'helper'

describe Mobitex::Outbox do

  describe 'with module configuration' do

    before do
      Mobitex.configure do |config|
        config.api_site       = 'http://api.example.com/module.php'
        config.api_user       = 'Module User'
        config.api_pass       = 'Module Password'
        config.message_sender = 'Module Sender'
        config.message_type   = 'sms_flash'
      end
    end

    after do
      Mobitex.reset
    end

    it 'inherits module configuration' do
      outbox = Mobitex::Outbox.new

      outbox.api_site.must_equal       'http://api.example.com/module.php'
      outbox.api_user.must_equal       'Module User'
      outbox.api_pass.must_equal       'Module Password'
      outbox.message_sender.must_equal 'Module Sender'
      outbox.message_type.must_equal   'sms_flash'
    end

    describe 'with class configuration' do

      describe 'during initialization' do
        it 'overrides module configuration' do
          outbox = Mobitex::Outbox.new({:api_site => 'http://api.example.com/class.php', :api_user => 'Class Username'})

          outbox.api_site.must_equal       'http://api.example.com/class.php'
          outbox.api_user.must_equal       'Class Username'
          outbox.api_pass.must_equal       'Module Password'
          outbox.message_sender.must_equal 'Module Sender'
          outbox.message_type.must_equal   'sms_flash'
        end
      end

      describe 'after initilization' do
        it 'overrides module configuration after initialization' do
          outbox = Mobitex::Outbox.new
          outbox.api_site = 'http://api.example.com/class.php'
          outbox.api_user = 'Class Username'

          outbox.api_site.must_equal       'http://api.example.com/class.php'
          outbox.api_user.must_equal       'Class Username'
          outbox.api_pass.must_equal       'Module Password'
          outbox.message_sender.must_equal 'Module Sender'
          outbox.message_type.must_equal   'sms_flash'
        end
      end

    end

  end

end
