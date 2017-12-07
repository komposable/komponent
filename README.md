# Komponent

## Installation

```ruby
gem 'komponent'
```

Modify your webpacker config to:

```
# config/webpacker.yml
source_path: frontend
```

## Usage

Generate new component with `component` generator:

`rails generate component button`

And use it in your views with helper. You can pass `locals`, or `block` to component helper.

`= component('button')`

Locals passed in to component are accessible as instance variables.

```
= component('button', color: :red)

.button
  = @color
```

You can define custom helpers in `ButtonComponent`:

```
class ButtonComponent
  def bar
    "foo"
  end
end

.button
  = bar
```

You can set properties in `ButtonComponent` too:

```
class ButtonComponent
  property :foo, default: "bar", required: true
end

.button
  = @foo
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ouvrages/komponent.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
