require 'mobitex/connection'

module Mobitex

  class HTTPDelivery

    def initialize(values)
      self.settings = {
          :user => nil,
          :pass => nil
      }.merge!(values)
    end

    attr_accessor :settings

    def deliver!(message)
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
    end

    private

    def connection
      @connection ||= Connection.new('http://api.statsms.net')
    end

  end

end
