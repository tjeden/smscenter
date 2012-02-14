require 'helper'

describe Mobitex do

  after do
    Mobitex.reset
  end

  describe '.respond_to?' do
    it 'takes an optional argument' do
      Mobitex.respond_to?(:new, true).must_equal true
    end
  end

  describe '.new' do
    it 'returns an Mobitex::Outbox' do
      Mobitex.new.must_be_instance_of Mobitex::Outbox
    end
  end

  describe '.api_site' do
    it 'returns the default API site' do
      Mobitex.api_site.must_equal 'http://api.statsms.net'
    end
  end

  describe '.api_site=' do
    it 'sets custom API site' do
      Mobitex.api_site = 'http://api.example.com'
      Mobitex.api_site.must_equal 'http://api.example.com'
    end
  end

  describe '.api_user' do
    it 'returns the default API user' do
      Mobitex.api_user.must_equal nil
    end
  end

  describe '.api_user=' do
    it 'sets the API user' do
      Mobitex.api_user = 'Mobitex User'
      Mobitex.api_user.must_equal 'Mobitex User'
    end
  end

  describe '.api_pass' do
    it 'returns the default API password' do
      Mobitex.api_pass.must_equal nil
    end
  end

  describe '.api_pass=' do
    it 'sets the API password' do
      Mobitex.api_pass = 'Mobitex Password'
      Mobitex.api_pass.must_equal 'Mobitex Password'
    end
  end

  describe '.message_sender' do
    it 'returns the default message sender' do
      Mobitex.message_sender.must_equal 'SMS Service'
    end
  end

  describe '.message_sender=' do
    it 'sets the message sender' do
      Mobitex.message_sender = 'My Sender'
      Mobitex.message_sender.must_equal 'My Sender'
    end
  end

  describe '.message_type' do
    it 'returns the default message type' do
      Mobitex.message_type.must_equal 'sms'
    end
  end

  describe '.message_type=' do
    it 'sets the message type' do
      Mobitex.message_type = 'concat'
      Mobitex.message_type.must_equal 'concat'
    end
  end

  describe '.configure' do
    it 'sets the configuration in a block' do
      Mobitex.configure do |config|
        config.api_site       = 'http://api.example.com'
        config.api_user       = 'Mobitex User'
        config.api_pass       = 'Mobitex Password'
        config.message_sender = 'My Sender'
        config.message_type   = 'concat'
      end

      Mobitex.api_site.must_equal       'http://api.example.com'
      Mobitex.api_user.must_equal       'Mobitex User'
      Mobitex.api_pass.must_equal       'Mobitex Password'
      Mobitex.message_sender.must_equal 'My Sender'
      Mobitex.message_type.must_equal   'concat'
    end
  end

  describe '.options' do
    it 'returns configuration as Hash' do
      Mobitex.configure do |config|
        config.api_site       = 'http://api.example.com'
        config.api_user       = 'Mobitex User'
        config.api_pass       = 'Mobitex Password'
        config.message_sender = 'My Sender'
        config.message_type   = 'concat'
      end

      options = Mobitex.options
      options[:api_site].must_equal       'http://api.example.com'
      options[:api_user].must_equal       'Mobitex User'
      options[:api_pass].must_equal       'Mobitex Password'
      options[:message_sender].must_equal 'My Sender'
      options[:message_type].must_equal   'concat'
    end
  end

end
