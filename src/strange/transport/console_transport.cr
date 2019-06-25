require "./transport"

class Strange
  # `Transport` for logging messages to STDOUT and STDERR
  class ConsoleTransport < Transport

    def log(message, level)
      return unless level <= @level
      message = @formatter.format(message, level)

      if level <= Strange::ERROR
        STDERR << message << "\r\n"
      else
        STDOUT << message << "\r\n"
      end

    end
  end
end
