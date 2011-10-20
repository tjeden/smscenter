require "bundler/setup"

module SmsCenter
  class Sms
    def initialize(options = {})
    end

    def deliver
      c = Curl::Easy.http_post("http://api.statsms.net/send.php")
      puts c.body_str
      true
    end
  end
end

