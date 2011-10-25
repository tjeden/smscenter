module Mobitex

  class ConnectionError < StandardError
    attr_reader :response

    def initialize(response, message = nil)
      @response = response
      @message  = message
    end

    def to_s
      message = "Failed."
      message << "  Response code = #{response.code}." if response.respond_to?(:code)
      message << "  Response message = #{response.message}." if response.respond_to?(:message)
      message
    end
  end

  # Raised when a Timeout::Error occurs.
  class TimeoutError < ConnectionError
    def initialize(message)
      @message = message
    end
    def to_s; @message ;end
  end

  # 3xx Redirection
  class Redirection < ConnectionError # :nodoc:
    def to_s; response['Location'] ? "#{super} => #{response['Location']}" : super; end
  end

  # 4xx Client Error
  class ClientError < ConnectionError; end # :nodoc:

  # 5xx Server Error
  class ServerError < ConnectionError; end # :nodoc:

  # Delivery errors
  class DeliveryError < StandardError
    attr_reader :response

    def initialize(response, message = nil)
      @response = response
      @message  = message
    end

    def to_s
      message = "Delivery Failed."
      message << "  Delivery Status = #{response['Status']}." if response.has_key?('Status')
      message << "  Delivery Id = #{response['Id']}." if response.has_key?('Id')
      message << "  Delivery Number = #{response['Number']}." if response.has_key?('Number')
      message
    end
  end

  class DeliveryCallbackError < DeliveryError; end

  class UnauthorizedAccess < DeliveryError; end

  class BlankText < DeliveryError; end

  class NoSender < DeliveryError; end

  class TextTooLong < DeliveryError; end

  class BadNumber < DeliveryError; end

  class BadType < DeliveryError; end

  class TypeNotSupported < DeliveryError; end

  class SenderUnauthorized < DeliveryError; end

  class System < DeliveryError; end

  class EmptyAccount < DeliveryError; end

  class AccountInactive < DeliveryError; end

  class DestinationNetworkUnavailable < DeliveryError; end

  class BadMessageId < DeliveryError; end

end