module Mobitex

  class Message
    TYPES                    = %w(sms concat sms_flash wap_push binary).freeze
    NUMBER_REGEXP            = /^\d{11}$/.freeze
    NUMERIC_FROM_REGEXP      = /^\d{1,16}$/.freeze
    ALPHANUMERIC_FROM_REGEXP = /^[a-zA-Z0-9]{1,11}$/.freeze
    FROM_REGEXP              = Regexp.union(NUMERIC_FROM_REGEXP, ALPHANUMERIC_FROM_REGEXP).freeze
    EXT_ID_CHARACTERS        = '!@#$%^&*()_+-={}|[]:<>'.freeze
    EXT_ID_REGEXP            = Regexp.new('^[a-zA-Z0-9' + Regexp.escape(EXT_ID_CHARACTERS) + ']{0,50}$').freeze
    WAP_PUSH_REGEXP          = /\S+\|https?\:\/\//
    DOUBLE_CHARACTERS        = '[]~^{}|\\'.freeze
    MAX_LENGTH               = {'sms' => 160, 'sms_flash' => 160, 'concat' => 459, 'wap_push' => 225, 'binary' => 280}.freeze

    attr_accessor :type, :number, :text, :from, :ext_id
    alias :to  :number
    alias :to= :number=

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

    def sanitized_from
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

    # Validations

    def type_valid?
      TYPES.include?(type.to_s)
    end

    def number_valid?
      !!(number.to_s =~ NUMBER_REGEXP)
    end

    def text_valid?
      length > 0 && length <= MAX_LENGTH[type] && !!(text =~ /[^[:space:]]/) && (type != 'wap_push' || !!(text =~ WAP_PUSH_REGEXP))
    end

    def from_valid?
      !!(from.to_s =~ FROM_REGEXP)
    end

    def ext_id_valid?
      !!(ext_id.to_s =~ EXT_ID_REGEXP)
    end

  end

end