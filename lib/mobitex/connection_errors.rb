module Mobitex

  class ConnectionError < StandardError
    attr_reader :response

    def initialize(response, message = nil)
      @response = response
      @message  = message
    end

    def to_s
      message = "Connection Failed."
      message << "  Response Code = #{response.code}." if response.respond_to?(:code)
      message << "  Response Message = #{response.message}." if response.respond_to?(:message)
      message
    end

  end

  # Raised when a Timeout::Error occurs.
  class TimeoutError < ConnectionError

    def initialize(message)
      @message = message
    end

    def to_s
      @message
    end

  end

  # 3xx Redirection
  class Redirection < ConnectionError # :nodoc:

    def to_s
      response['Location'] ? "#{super} => #{response['Location']}" : super
    end

  end

  # 4xx Client Error
  class ClientError < ConnectionError
  end

  # 5xx Server Error
  class ServerError < ConnectionError
  end

end
