module Mobitex

  class TestDelivery
    attr_accessor :settings

    def self.deliveries
      @@deliveries ||= []
    end

    def self.deliveries=(deliveries)
      @@deliveries = deliveries
    end

    def initialize(values)
      @settings = {}
    end

    def deliver!(message)
      self.class.deliveries << message
    end

  end

end
