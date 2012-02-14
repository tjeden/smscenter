require 'net/http'

require 'mobitex/config'
require 'mobitex/connection'
require 'mobitex/connection_errors'
require 'mobitex/delivery_errors'
require 'mobitex/outbox'
require 'mobitex/version'
require 'mobitex/test_helpers'

module Mobitex
  extend Mobitex::Config

  class << self

    # Alias for Mobitex::Outbox.new
    #
    # @return [Mobitex::Outbox]
    def new(options = {})
      Mobitex::Outbox.new(options)
    end

    # Delegate to IFormat::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)

      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private = false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end

  end

end
