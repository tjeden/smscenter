require 'cgi'

module Mobitex

  # Mobitex::TestHelpers provide a faciality to test mobitex gem
  module TestHelpers
    extend self

    def assert_delivered(message, options = {}, msg = nil, &block)
      options[:number] ||= '48123456789'
      options[:type]   ||= 'sms'

      number_param  = "number=#{CGI::escape(options[:number])}"
      content_param = "text=#{CGI::escape(message)}"
      type_param    = "type=#{CGI::escape(options[:type])}"

      stub_request(:post, Mobitex.api_site + '/send.php').
          with(:headers => {'Accept' => '*/*'}).
          to_return(:status => 200, :body => "Status: 002, Id: 03a72a49fb9595f3737bc4a2519ff283, Number: #{options[:number]}", :headers => {})

      yield

      assert_requested(:post, Mobitex.api_site + '/send.php', :times => 1) do |req|
        req.body.index(number_param) && req.body.index(type_param) && req.body.index(content_param) && req.body.index('pass=faked') && req.body.index('user=faked')
      end
    end

  end

end
