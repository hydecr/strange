# Strange

Strange is a logger which provides a maximum amount of configuration options, with minimal setup. It supports setting the log level via an environment variable (wip), colorized output, multiple formatters, and transports which allow you to decide where the logs go.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     strange:
       github: hydecr/strange
   ```

2. Run `shards install`

## Usage

Strange is super easy to get started with, as it requires no configuration by default.

```crystal
require "strange"

logger = Strange.new

# The default log level is set as `Strange::Debug`
logger.debug("'If he be Mr. Hyde' he had thought, 'I shall be Mr. Seek.'")
```

However if one wishes, the configuration can get pretty crazy (as you'll see in the below documentation).

```crystal
require "strange"
require "strange/formatter/json_formatter"
require "strange/transport/file_transport"

logger = Strange.new(level: Strange::DEBUG, transports: [
  Strange::ConsoleTransport.new,    # Level will default to `Strange::DEBUG`
  Strange::FileTransport.new(
    file: File.expand_path("~/Desktop/test.log", __DIR__),
    level: Strange::ERROR,
    formatter: Strange::JSONFormatter.new(
      indent: true
    )
  )
])

# This will be logged to the console appended to the
# file /var/log/strange-test.log as JSON.
logger.crit("If I am the chief of sinners, I am the chief of sufferers also.")
```

## Level

Logging levels for strange are as defined in [RFC5424](https://tools.ietf.org/html/rfc5424):

| Level   | Value  |
|:--------|:------:|
| EMERG   |   0    |
| ALERT   |   1    |
| CRIT    |   2    |
| ERROR   |   3    |
| WARNING |   4    |
| NOTICE  |   5    |
| INFO    |   6    |
| DEBUG   |   7    |

with each having a corresponding method of the same name.

## Transports

Strange uses transports as a means of sending your message where it belongs. Included by default are `Strange::ConsoleTransport`, which is the default transport, and `Strange::FileTransport` which can be used for logging to a file. Transports are also simple to create. All you have to do is extend the `Strange::Transport` class and define a `#log` method.

All transports have to define a log method, which is called every time `Logger#log` is called.

```crystal
class MySimpleTransport < Strange::Transport
  def log(message, level)
    return unless level <= @level
    puts message
  end
end
```

You can register your logger in the `Strange` constructor or by pushing it to `Strange#transports`.

```
logger.transports << MySimpleTransport.new
```

## Formatters

Formatters define how logs are formatted and are included on a per-transport basis. Included by default are the `ColoredFormatter`, `BasicFormatter`, and `JSONFormatter`, but you can pretty easily create a formatter for whatever you want by simply extending `Strange::Formatter` and providing a `#format` method.

```crystal
class MyFormatter < Strange::Formatter
  def format(message, level)
    "#{level.to_s} - #{message}"
  end
end
```

## Notes

> All transports and formatters besides `Strange::ConsoleTransport` and `Strange::BasicFormatter`  have to be require explicitly.

## Contributing

1. Fork it (<https://github.com/hydecr/strange/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
