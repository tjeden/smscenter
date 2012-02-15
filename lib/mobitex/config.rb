module Mobitex

  # Defines constants and methods related to configuration
  module Config

    # The API URL that will be used to connect if none is set
    DEFAULT_API_SITE = 'http://api.statsms.net'

    # The API usersname if none is set
    DEFAULT_API_USER = nil

    # The API password if none is set
    DEFAULT_API_PASS = nil

    # The message sender if none is set
    #
    # This option can be set to:
    # * 16-digit number, eg. "48600123456"
    # * 11-symbol alphanumeric String, eg. "Mobitex"
    DEFAULT_MESSAGE_FROM = 'SMS Service'

    # The message type if none is set
    DEFAULT_MESSAGE_TYPE = 'sms'

    # An array of valid keys in the options hash when configuring a {Mobitex::Outbox}
    VALID_OPTIONS_KEYS = [
        :api_site,
        :api_user,
        :api_pass,
        :message_from,
        :message_type
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
      self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{ |k| options[k] = send(k) }
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.api_site     = DEFAULT_API_SITE
      self.api_user     = DEFAULT_API_USER
      self.api_pass     = DEFAULT_API_PASS
      self.message_from = DEFAULT_MESSAGE_FROM
      self.message_type = DEFAULT_MESSAGE_TYPE
      self
    end

  end

end