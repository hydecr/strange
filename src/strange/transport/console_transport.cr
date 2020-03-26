require "./transport"

class Strange
  # `Transport` for logging messages to STDOUT and STDERR
  class ConsoleTransport < Transport

    def log(message, level)
      sync do
        next unless level <= @level
        message = @formatter.format(message.to_s, level)

        if level <= Strange::ERROR
          STDERR << message.to_s << "\r\n"
        else
          STDOUT << message.to_s << "\r\n"
        end
      end
    end

    def sync(&block)
      out_stat = STDOUT.sync?
      err_stat = STDERR.sync?
      STDOUT.sync = false
      STDERR.sync = false
      yield
      STDOUT.sync = out_stat
      STDERR.sync = err_stat
    end
  end
end
