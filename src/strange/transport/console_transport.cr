require "./transport"

class Strange
  # `Transport` for logging messages to STDOUT and STDERR
  class ConsoleTransport < Transport

    def log(message, level)
      sync do
        next unless level <= @level
        message = @formatter.format(message, level)

        if level <= Strange::ERROR
          STDERR << message << "\r\n"
        else
          STDOUT << message << "\r\n"
        end
      end
    end

    def sync(&block)
      status = STDOUT.sync?
      STDOUT.sync = false
      yield
      STDOUT.sync = status
    end
  end
end
