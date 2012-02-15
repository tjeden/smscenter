module Mobitex

  class Message
    TYPES                    = %w(sms concat sms_flash wap_push binary)
    NUMBER_REGEXP            = /^\d{11}$/
    NUMERIC_FROM_REGEXP      = /^\d{1,16}$/
    ALPHANUMERIC_FROM_REGEXP = /^\[a-zA-Z0-9]{1,11}$/
    FROM_REGEXP              = Regexp.union(NUMERIC_FROM_REGEXP, ALPHANUMERIC_FROM_REGEXP)
    EXT_ID_CHARACTERS        = '!@#$%^&*()_+-={}|[]:<>'
    EXT_ID_REGEXP            = Regexp.new('^[a-zA-Z0-9' + Regexp.escape(EXT_ID_CHARACTERS) + ']{,50}$')
    DOUBLE_CHARACTERS        = '[]~^{}|\\'

    attr_accessor :type, :number, :text, :from, :ext_id

    def self.type_valid?(type)
      TYPES.include?(type.to_s)
    end

    def self.number_valid?(number)
      number.to_s =~ NUMBER_REGEXP
    end

    def self.from_valid?(from)
      from.to_s =~ FROM_REGEXP
    end

    def self.ext_id_valid?(ext_id)
      ext_id.to_s =~ EXT_ID_REGEXP
    end

    def initialize(number, text = '', options = {})
      self.number = number
      self.text   = text
      self.from   = options[:from]
      self.ext_id = options[:ext_id]
      self.type   = options[:type]
    end

    def type
      @type ||= length > 160 ? 'concat' : 'sms'
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