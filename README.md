# pico_container

Minimal DI container

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  pico_container:
    github: artworx/pico_container
```

## Usage

```crystal
require "pico_container"

class Dependency
  inject
end

class Example
  inject Dependency

  def initialize(@dependency : Dependency)
  end
end

class Container
  include PicoContainer
end

container = Container.new
p container.create(Example)
#<Example:0x1c0bd80 @dependency=#<Dependency:0x1c0af20>>
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/artworx/pico_container/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [artworx](https://github.com/artworx) Alexandru Keszeg - creator, maintainer
