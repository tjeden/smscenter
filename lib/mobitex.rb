require 'mobitex/connection'
require 'mobitex/errors'
require 'mobitex/outbox'
require 'mobitex/version'

module Mobitex
  DEFAULT_SITE = 'http://api.statsms.net'.freeze

  # API address
  @@site = DEFAULT_SITE unless defined? @@site
  def self.site; @@site; end
  def self.site=(site); @@site = site; end

  def self.configure
    yield self
  end

end
