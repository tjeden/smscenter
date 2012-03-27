module Mobitex

  class Response
    attr_reader :statuses

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