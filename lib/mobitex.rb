require 'active_support'
require 'mobitex/connection'
require 'mobitex/errors'
require 'mobitex/sms'
require 'mobitex/version'

module Mobitex

  # API address
  mattr_accessor :site
  @@site = 'http://api.statsms.net'

  # Service user login
  mattr_accessor :user
  @@user = ''

  # Service user password
  mattr_accessor :pass
  @@pass = ''

  # Default delivery options
  mattr_accessor :default
  @@default = {
      :from  => '',
      :from2 => ''
  }

  def self.configure
    yield self
  end

end