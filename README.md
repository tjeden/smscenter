Mobitex gem - wrapper to mobitex API
====================================

[![Build Status](https://secure.travis-ci.org/tjeden/smscenter.png)][travis]
[![Dependency Status](https://gemnasium.com/tjeden/smscenter.png?travis)][gemnasium]

[travis]: http://travis-ci.org/tjeden/smscenter
[gemnasium]: https://gemnasium.com/tjeden/smscenter


How to use it?
--------------

Gemfile:

``` ruby
gem 'mobitex'
``` 
    
Code:

``` ruby
outbox = Mobitex::Outbox.new(:api_user => 'username', :api_pass => 'password')
outbox.deliver('48123456789', 'Spam bacon sausage and spam')
```

Enjoy!

More usage examples
-------------------

### Global configuration

You can set up global configuration:

``` ruby
Mobitex.configure do |config|
  config.api_user = 'username'
  config.api_pass = 'password'
end
```

Then you can just:

``` ruby
Mobitex.deliver('48123456789', 'Egg sausage and bacon')
```

...which really is a shortcut for:

``` ruby
Mobitex::Outbox.new.deliver('48123456789', 'Egg sausage and bacon')
```

### Multiple Outboxes

``` ruby
Mobitex.configure do |config|
  config.api_user     = 'user1'
  config.api_pass     = 'pass2'
  config.message_from = 'FullService'
end
```

You can have multiple simultaneous clients:

``` ruby
outbox1 = Mobitex::Outbox.new                                             # Credentials and delivery options taken from global config
outbox2 = Mobitex::Outbox.new(:message_from => 'SpamHouse')               # Custom "message_from" option, credentials from global config
outbox3 = Mobitex::Outbox.new(:api_user => 'user3', :api_pass => 'pass3') # Custom credentials, "message_from" option from global config

outbox1.deliver('48123456789', 'Hello from FullService!')
outbox2.deliver('48123456789', 'SpamHouse welcomes you!')
outbox3.deliver('48123456789', 'Other API client will be charged here')
```

How to test it?
---------------

Currently Mobitex supports `minitest`, `test/unit` and `rspec` and requires `webmock`.

Require appropriate library for your testing framework:

``` ruby
require 'mobitex/minitest'
require 'mobitex/test_unit'
require 'mobitex/rspec'
```

Then use `assert_delivered`:

``` ruby
describe 'Dispatcher' do

  before do
    WebMock.reset!
    WebMock.disable_net_connect!
  end

  it 'delivers short text message' do
    outbox = Mobitex::Outbox.new(:api_user => 'faked', :api_pass => 'faked')
    assert_delivered 'I want to play a game' do
      outbox.deliver('48123456789', 'Spam bacon spam tomato and spam')
    end
  end

end
```
    
`assert_delivered` has a few options:

``` ruby
# It can check custom number
assert_delivered('some text', :number => '48666666666') do ...

# It can check if long sms has been send (more than 160 chars)
assert_delivered('some long text', :type => 'concat') do ...
``` 
    
Setup tests
-----------

Don't forget to initialize web\_mock in your `before`/`setup` step:

``` ruby
def setup
  WebMock.reset!
  WebMock.disable_net_connect!
end
``` 
