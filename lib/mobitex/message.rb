module Mobitex

  class Message
    LONG_TYPE         = 'concat'
    DOUBLE_CHARACTERS = '[]~^{}|\\'

    attr_accessor :type, :number, :text, :from, :ext_id

    def initialize(number, text = '', options = {})
      self.number = number
      self.text   = text
      self.from   = options[:from]
      self.ext_id = options[:ext_id]
    end

    def type
      length > 160 ? LONG_TYPE : 'sms'
    end

    def length
      text.length + text.count(DOUBLE_CHARACTERS)
    end

    def from
      if @from.is_a?(Numeric) || @from =~ /^\d+$/
        @from.to_s[0...16]
      else
        @from.to_s[0...11]
      end
    end

    def to_params
      {
          :type   => type,
          :number => number,
          :text   => text,
          :from   => from,
          :ext_id => ext_id
      }
    end

  end

end