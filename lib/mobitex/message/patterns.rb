# -*- encoding: utf-8 -*-

module Mobitex

  class Message

    module Patterns
      TYPES                    = %w(sms concat sms_flash wap_push binary)
      NUMBER_REGEXP            = /^\d{11}$/
      BULK_DELIMITER           = ','
      BULK_NUMBERS_LIMIT       = 500
      BULK_NUMBERS_REGEXP      = %r!^(\d{11}#{Regexp.escape(BULK_DELIMITER)}){0,#{BULK_NUMBERS_LIMIT - 1}}\d{11}$!o
      NUMERIC_FROM_REGEXP      = /^\d{1,16}$/
      ALPHANUMERIC_FROM_REGEXP = /^[a-zA-Z0-9]{1,11}$/
      FROM_REGEXP              = Regexp.union(NUMERIC_FROM_REGEXP, ALPHANUMERIC_FROM_REGEXP)
      MESSAGE_ID_CHARACTERS    = '!@#$%^&*()_+-={}|[]:<>'
      MESSAGE_ID_REGEXP        = %r!^[a-zA-Z0-9#{Regexp.escape(MESSAGE_ID_CHARACTERS)}]{0,50}$!o
      WAP_PUSH_REGEXP          = /\S+\|https?\:\/\//
      DOUBLE_CHARACTERS        = "[]~^{}|\\\r\n"
      STANDARD_CHARACTERS      = %q{@£$¥èéùìòÇØøÅå_^{}\[~]|ÆæßÉ!"#¤%&'()*+,-./:;<=>?ÄÖÑÜ§¿äöñüà }
      SPECIAL_CHARACTER_REGEXP = %r![^a-zA-Z0-9#{Regexp.escape(STANDARD_CHARACTERS)}\r\n]!o
      MAX_LENGTH               = {'sms' => 160, 'sms_flash' => 160, 'concat' => 459, 'wap_push' => 225, 'binary' => 280}
      MAX_LENGTH.default       = -1
      NON_WHITESPACE_REGEXP    = %r![^\s#{[0x3000].pack("U")}]!
    end

  end

end
