require 'mobitex/delivery/file_delivery'
require 'mobitex/delivery/http_delivery'
require 'mobitex/delivery/test_delivery'
require 'singleton'

module Mobitex

  class Configuration
    include Singleton

    def initialize
      reset!
      super
    end

    def delivery_method(method = nil, settings = {})
      return @delivery_method if @delivery_method && method.nil?

      @delivery_method = lookup_delivery_method(method).new(settings)
    end

    def lookup_delivery_method(method)
      case method
        when :http, nil then Mobitex::HTTPDelivery
        when :file      then Mobitex::FileDelivery
        when :test      then Mobitex::TestDelivery
        else method
      end
    end

    private

    def reset!
      @delivery_method = nil
    end

  end

end
