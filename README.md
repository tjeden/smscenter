Mobitex gem - wrapper to mobitex API
===================================

How to use it?
-------------

Gemfile:

    gem 'mobitex'

Code:

    outbox = Mobitex::Outbox.new('username', 'password')
    outbox.deliver_sms('48500500500', 'you have got mail')

Enjoy!

