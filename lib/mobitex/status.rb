module Mobitex

  class Status
    attr_reader :attributes

    def self.parse(raw_status)
      attributes = {}

      raw_status.to_s.split(',').map do |raw_attribute|
        part = raw_attribute.partition(':')
        attributes[part.first.strip] = part.last.strip
      end

      new(attributes)
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    def status
      attributes['Status']
    end

    def id
      attributes['Id']
    end

    def number
      attributes['Number']
    end

    def valid?
      status == '002'
    end

  end

end