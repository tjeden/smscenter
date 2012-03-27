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
Mobitex.configure { delivery_method :http, { :user => 'username', :pass => 'password' } }
Mobitex.deliver(:to => '48123456789', :body => 'Spam bacon sausage and spam')
```

Enjoy!

More usage examples
-------------------

First, you must setup delivery method:

``` ruby
Mobitex.configure do
  delivery_method :http, {
    :user => 'username',
    :pass => 'password'
  }
end
```

Then you can just:

``` ruby
Mobitex.deliver(:to => '48123456789', :body => 'Egg sausage and bacon')
```

...which really is a shortcut for:

``` ruby
Mobitex::Message.new(:to => '48123456789', :body => 'Egg sausage and bacon')
```

You can use DSL to create new message:

``` ruby
message = Mobitex::Message.new do
  to   '48123456789'
  body 'Egg, Bacon, Spam, Baked Beans, Spam, Sausage and Spam'
end
```
