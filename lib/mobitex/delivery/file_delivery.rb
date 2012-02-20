module Mobitex

  class FileDelivery

    def initialize(values)
      self.settings = {
          :location => './messages'
      }.merge!(values)
    end

    attr_accessor :settings

    def deliver!(message)
    end

  end

end
