require "./formatter/formatter"
require "./formatter/basic_formatter"

require "./transport/transport"
require "./transport/console_transport"

class Strange

  # Logging levels based off of RFC5424
  enum Level
    EMERG   = 0
    ALERT   = 1
    CRIT    = 2
    ERROR   = 3
    WARNING = 4
    NOTICE  = 5
    INFO    = 6
    DEBUG   = 7
  end

  {% for level in Level.constants %}
    # Shortcut to `Level::{{level.id}}`
    {{level.id}} = Level::{{level.id}}
  {% end %}

  # The default log level for all instances of `Strange`.
  class_property level : Level = Level::WARNING

  # An array of `Transport`s to use.
  property transports : Array(Transport)

  def initialize(
    level = nil,
    transports = nil
  )
    # Set the level. If the level is `:env` then we set it
    # based on the `LOG_LEVEL` environment variable, if
    # its `nil` we set it to `WARNING`, otherwise we
    # set it to the defined level.
    if level.to_s == "env"
      @@level = env_level
    elsif level.is_a?(Strange::Level)
      @@level = level
    else
      raise "Unsupported level #{level}"
    end

    # Create our transports array
    @transports = transports || [] of Transport

    # If there isn't anything in the array lets make sure we have
    # one transport.
    if @transports.empty?
      @transports << ConsoleTransport.new(level: @@level)
    end
  end

  {% for level in Level.constants %}
    # Logs the `message` if the set `Level` is less than or
    # equal to `:{{ level.id }}`
    def {{level.id.downcase}}(message)
      log(message, {{ level.id }})
    end
  {% end %}

  # Logs a message at a given level through each transport
  # defined in `#transports`.
  def log(message, level)
    @transports.each do |transport|
      transport.log(message, level)
    end
  end

  private def env_level
    return Strange::DEBUG unless ENV["LOG_LEVEL"]?
    case ENV["LOG_LEVEL"]
    when "EMERG"
      Level::EMERG
    when "ALERT"
      Level::ALERT
    when "CRIT"
      Level::CRIT
    when "ERROR"
      Level::ERROR
    when "WARNING"
      Level::WARNING
    when "NOTICE"
      Level::NOTICE
    when "INFO"
      Level::INFO
    when "DEBUG"
      Level::DEBUG
    else
      raise "Unsupported log level #{ENV["LOG_LEVEL"]}"
    end
  end
end
