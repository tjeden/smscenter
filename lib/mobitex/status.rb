module Mobitex

  class Status
    attr_reader :attributes

    # Public: Parses single raw status from Mobitex response.
    #
    # Examples
    #
    #   status = Mobitex::Status.parse('Status: 001, Id: 3e2dc963309c6b574f6c7467a62ef25b, Number: 123456789')
    #   status.status # => '001'
    #   status.id     # => '3e2dc963309c6b574f6c7467a62ef25b'
    #   status.number # => '123456789'
    #
    # Returns Status object.
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