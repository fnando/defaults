# Defaults

[![Travis-CI](https://travis-ci.org/fnando/defaults.svg)](https://travis-ci.org/fnando/defaults)
[![Code Climate](https://codeclimate.com/github/fnando/defaults/badges/gpa.svg)](https://codeclimate.com/github/fnando/defaults)
[![Test Coverage](https://codeclimate.com/github/fnando/defaults/badges/coverage.svg)](https://codeclimate.com/github/fnando/defaults/coverage)
[![Gem](https://img.shields.io/gem/v/defaults.svg)](https://rubygems.org/gems/defaults)
[![Gem](https://img.shields.io/gem/dt/defaults.svg)](https://rubygems.org/gems/defaults)

## Instalation

Add this line to your application's Gemfile:

```ruby
gem "defaults"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install defaults


## Usage

Here are the rules:

1. Assigned attributes have precedence over default values
2. Default values have precedence over database defaults.

Add the method call `defaults` to your model.

```ruby
class Page < ActiveRecord::Base
  defaults title: "New page", body: "Put your text here"
end
```

Attributes will be set only if it's a new record and the attribute is blank.

Retrieve the default attribute with the `default_for` instance method:

```ruby
@page.default_for(:title)
```

You can pass callables (any objects that respond to `.call()` or `.call(record)`) as attribute:

```ruby
class Expiration
  def self.call
    Time.now
  end
end

class Checksum
  def self.call(user)
    Digest::SHA1.hexdigest(user.name.to_s, user.email.to_s)
  end
end

class User < ApplicationRecord
  defaults checksum: Checksum,
           expires_at: -> { Time.now }
end
```

You can override the default attributes as follow:

```ruby
Page.default_values = {title: "Here's your new page", body: "Write your page text"}
```

## Maintainer

Nando Vieira - http://nandovieira.com

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
