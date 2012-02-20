require 'mobitex/configuration'
require 'mobitex/message'

module Mobitex

  def self.new(*args, &block)
    Mobitex::Message.new(args, &block)
  end

  def self.configure(&block)
    return unless block_given?

    if block.arity == 1
      yield Configuration.instance
    else
      Configuration.instance.instance_eval &block
    end
  end

  def self.delivery_method
    Configuration.instance.delivery_method
  end

  def self.deliver(*args, &block)
    message = self.new(args, &block)
    message.deliver
    message
  end

  def self.register_observer(observer)
    unless @@delivery_notification_observers.include?(observer)
      @@delivery_notification_observers << observer
    end
  end

  private

  @@delivery_notification_observers = []

  def self.inform_observers(message)
    @@delivery_notification_observers.each do |observer|
      observer.delivered_message(message)
    end
  end

end
