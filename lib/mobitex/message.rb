require 'mobitex/message/configuration'
require 'mobitex/message/patterns'

module Mobitex

  class Message
    include Patterns

    attr_accessor :delivery_handler
    attr_writer   *Configuration::VALID_OPTIONS

    # Public: Set default values for Message attributes.
    #
    # Examples
    #
    #   Mobitex::Message.configure do |config|
    #     config.body = 'My default body'
    #   end
    #
    #   message = Mobitex::Message.new
    #   message.body
    #   # => 'My default body'
    #
    def self.configure(&block)
      return unless block_given?

      if block.arity == 1
        yield Configuration.instance
      else
        Configuration.instance.instance_eval &block
      end
    end

    # Public: Initialize a new Message.
    #
    # args  - Hash of attributes of the message.
    # block - An optional block that can be used to build a new message using DSL-like syntax.
    #
    # Examples
    #
    #   message = Mobitex::Message.new(:to => '48123456789', :body => 'Hello!')
    #
    #   message = Mobitex::Message.new do
    #     to   '48123456789'
    #     body 'Hello!'
    #   end
    #
    #   message = Mobitex::Message.new do |m|
    #     m.to   = '48123456789'
    #     m.body = 'Hello!'
    #   end
    #
    def initialize(*args, &block)
      @delivery_handler = nil
      @delivery_method  = Mobitex.delivery_method.dup

      options = args.first.respond_to?(:each_pair) ? args.first : {}
      Configuration::VALID_OPTIONS.each do |key|
        send("#{key}=", options[key] || options[key.to_sym] || Configuration.instance.send("#{key}"))
      end

      if block_given?
        if block.arity == 1
          yield self
        else
          instance_eval &block
        end
      end

      self
    end

    # Generate special accessors that act like readers when called without an argument or like writers when called
    # with argument.
    #
    # Examples
    #
    #   message = Mobitex::Message.new
    #   message.body 'Hello!' # This is equivalent to `message.body = 'Hello!'`
    #   message.body          # => 'Hello!'
    #
    Configuration::VALID_OPTIONS.each do |key|
      define_method key do |*value|         # def from(*value)
        if value.first                      #   if value.first
          self.send("#{key}=", value.first) #     self.send("from=", value.first)
        else                                #   else
          instance_variable_get("@#{key}")  #     instance_variable_get("@from")
        end                                 #   end
      end                                   # end
    end

    # Validation #######################################################################################################

    # Sanitization #####################################################################################################

    # Delivery #########################################################################################################

    def deliver
      if delivery_handler
        delivery_handler.deliver_sms(self){ do_delivery }
      else
        do_delivery
      end
      inform_observers
      self
    end

    def deliver!
      response = delivery_method.deliver!(self)
      inform_observers
      delivery_method.settings[:return_response] ? response : self
    end

    def delivery_method(method = nil, settings = {})
      return @delivery_method unless method

      @delivery_method = Mobitex::Configuration.instance.lookup_delivery_method(method).new(settings)
    end

    private

    def inform_observers
      Mobitex.inform_observers(self)
    end

    def do_delivery
      delivery_method.deliver!(self) if perform_deliveries
    rescue Exception => e # Net::HTTP errors
      raise e if raise_delivery_errors
    end

  end

end