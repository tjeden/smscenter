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
outbox = Mobitex::Outbox.new('username', 'password')
outbox.deliver('48123456789', 'Spam bacon sausage and spam')
```

Enjoy!

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
    
`assert_delivered` has few options:

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
