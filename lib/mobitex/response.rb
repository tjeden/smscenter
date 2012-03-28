module Mobitex

  class Response
    attr_reader :statuses

    # Public: Parses raw statuses from Mobitex response.
    #
    # Examples
    #
    #   response = Mobitex::Response.parse("Status: 001, Id: 3e2dc963309c6b574f6c7467a62ef25b, Number: 123456789\nStatus: 106, Id: 251eb8c426466a149bacf15f6c00eacf, Number: 987654321")
    #   response.statuses.length       # => 2
    #   response.statuses.first.status # => '001'
    #   response.statuses.first.id     # => '3e2dc963309c6b574f6c7467a62ef25b'
    #   response.statuses.first.number # => '123456789'
    #
    # Returns Response object.
    def self.parse(raw_response)
      statuses = []

      raw_response.lines.map do |raw_status|
        statuses << Status.parse(raw_status)
      end

      new(statuses)
    end

    def initialize(statuses = [])
      @statuses = statuses
    end

  end

end