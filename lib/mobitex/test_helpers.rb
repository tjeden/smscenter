module Mobitex
  # Mobitex::TestHelpers probied a faciality to test mobitex gem
  module TestHelpers

    module InstanceMethods
      def setup
        puts 'webmock'
        WebMock.reset!
        WebMock.disable_net_connect!
        stub_request(:post, "http://api.statsms.net/send.php").
          with( :headers => {'Accept'=>'*/*'}).
          to_return(:status => 200, :body => "Status: 002, Id: 03a72a49fb9595f3737bc4a2519ff283, Number: 4860X123456", :headers => {})
      end
    end
     
    def self.included(base)
      base.send :include, InstanceMethods
    end

    def assert_sms_send(text, options = {})
      options[:number] ||= '48123456789'
      options[:type]   ||= 'sms'
      text.gsub!(/ /,'\\\\+')
      
      number  = Regexp.new("number=#{options[:number]}")
      content = Regexp.new("text=#{text}")
      type    = Regexp.new("type=#{options[:type]}")

      assert_requested(:post, "http://api.statsms.net/send.php", :times => 1) do |req| 
        req.body =~ number && req.body =~ type && req.body =~ content && req.body =~ /pass=faked/ && req.body =~/user=faked/
      end
    end

  end
end
