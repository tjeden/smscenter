require 'singleton'

module Mobitex

  class Message

    class Configuration
      include Singleton

      VALID_OPTIONS = [
          :type,
          :from,
          :to,
          :body,
          :message_id,
          :perform_deliveries,
          :raise_delivery_errors
      ]

      attr_accessor *VALID_OPTIONS

      def initialize
        reset!
        super
      end

      private

      def reset!
        @type       = 'sms'
        @from       = 'SmsService'
        @to         = nil
        @body       = nil
        @message_id = nil

        @perform_deliveries    = true
        @raise_delivery_errors = true
      end

    end

  end

end
