module Mobitex

  class Inbox
    attr_accessor :handler, :request, :response

    def initialize(&handler)
      @handler = handler
    end

    def call(env)
      request = Rack::Request.new(env)
      @handler.call(sms) if @handler
      @response
    end

  end

end