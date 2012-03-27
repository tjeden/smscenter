require 'mobitex/connection'

module Mobitex

  class HTTPDelivery
    attr_accessor :settings
    attr_reader   :response

    def initialize(values)
      self.settings = {
          :user => nil,
          :pass => nil
      }.merge!(values)
    end

    def deliver!(message)
      @response = nil

      message.sanitize!

      raw_response = connection.post('/send.php', {
          :user   => settings[:user],
          :pass   => settings[:pass],
          :type   => message.type,
          :from   => message.from,
          :number => message.to,
          :text   => message.body,
          :ext_id => message.message_id
      })

      @response = raw_response

      settings[:return_response] ? raw_response : self
    end

    private

    def connection
      @connection ||= Connection.new('http://api.statsms.net')
    end

  end

end
