# Defaults

[![Tests](https://github.com/fnando/defaults/workflows/ruby-tests/badge.svg)](https://github.com/fnando/defaults)
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
  defaults title: "New page",
           body: "Put your text here"
end
```

Attributes will be set only if it's a new record and the attribute is blank.

Retrieve the default attribute with the `default_for` instance method:

```ruby
@page.default_for(:title)
```

You can pass callables (any objects that respond to `.call()` or
`.call(record)`) as attribute:

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
Page.default_values = {
  title: "Here's your new page",
  body: "Write your page text"
}
```

## Maintainer

- [Nando Vieira](https://github.com/fnando)

## Contributors

- <https://github.com/fnando/defaults/contributors>

## Contributing

For more details about how to contribute, please read
<https://github.com/fnando/defaults/blob/main/CONTRIBUTING.md>.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be
found at <https://github.com/fnando/defaults/blob/main/LICENSE.md>.

## Code of Conduct

Everyone interacting in the defaults project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/defaults/blob/main/CODE_OF_CONDUCT.md).
