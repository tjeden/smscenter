module Mobitex

  class Sms
    attr_accessor :type, :number, :text, :from, :ext_id

    def initialize(options = {})
    end

    def deliver!
      c = Curl::Easy.http_post('http://api.statsms.net/send.php')
      puts c.body_str
      true
    end
  end

end
