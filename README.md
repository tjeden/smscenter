Mobitex gem - wrapper to mobitex API
===================================

[![Build Status](https://secure.travis-ci.org/tjeden/smscenter.png)](http://travis-ci.org/tjeden/smscenter)

How to use it?
--------------

Gemfile:

    ``` ruby
    gem 'mobitex'
    ```
    
Code:

    ``` ruby
    outbox = Mobitex::Outbox.new('username', 'password')
    outbox.deliver_sms('48500500500', 'you have got mail')
    ```
    
Enjoy!

How to test it?
---------------

Currentle Mobitex supports only `test/unit` with webmock/test\_unit

Include `Mobitex::TestHelpers` in you test class and use `assert_sms_send`

    ``` ruby
    class SomeTest < Test::Unit::TestCase
      include Mobitex::TestHelpers

      def test_sms_delivery
        outbox = Mobitex::Outbox.new('faked', 'faked')
        outbox.deliver_sms('48123456789', 'you have got mail')

        assert_sms_send('you have got mail')
      end
    end
    ```
    
`assert_sms_send` has few options:

    ``` ruby
    # It can check custom number
    assert_sms_send('some text', :number => '48666666666')
    # It can check if long sms has been send (more than 160 chars)
    assert_sms_send('some long text', :type => 'concat')
    ```
    
Custom setup in tests
---------------------

If you use custom setup in your tests don't forget to initialize web\_mock in `setup`:

    ``` ruby
    def setup
      WebMock.reset!
      WebMock.disable_net_connect!
      stub_request(:post, "http://api.statsms.net/send.php").
        with( :headers => {'Accept'=>'*/*'}).
        to_return(:status => 200, :body => "Status: 002, Id: 03a72a49fb9595f3737bc4a2519ff283, Number: 4860X123456", :headers => {})
    end

Or you can just run super in `setup` method, it will stub requests and prepare web\_mock.
   
    ``` ruby
    def setup
      # some your code goes here
      super
    end
    ```

