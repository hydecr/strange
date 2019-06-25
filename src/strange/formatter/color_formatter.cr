require "colorize"
require "./formatter"

class Strange
  class ColorFormatter < Formatter
    alias ColorProcs = NamedTuple(
      emerg: Proc(String, Colorize::Object(String)),
      alert: Proc(String, Colorize::Object(String)),
      crit: Proc(String, Colorize::Object(String)),
      error: Proc(String, Colorize::Object(String)),
      warning: Proc(String, Colorize::Object(String)),
      notice: Proc(String, Colorize::Object(String)),
      info: Proc(String, Colorize::Object(String)),
      debug: Proc(String, Colorize::Object(String))
    )

    property colors : ColorProcs = {
      emerg:    ->(message : String) { message.colorize(:light_red)   },
      alert:    ->(message : String) { message.colorize(:red)         },
      crit:     ->(message : String) { message.colorize(:red)         },
      error:    ->(message : String) { message.colorize(:red)         },
      warning:  ->(message : String) { message.colorize(:yellow)      },
      notice:   ->(message : String) { message.colorize(:blue)        },
      info:     ->(message : String) { message.colorize(:light_blue)  },
      debug:    ->(message : String) { message.colorize(:cyan)  },
    }

    def format(text : String, level : Strange::Level)
      color_message(text, level)
    end

    private def color_message(message, level)
      case level
      when Strange::EMERG
        colors[:error].call(message)
      when Strange::ALERT
        colors[:alert].call(message)
      when Strange::CRIT
        colors[:crit].call(message)
      when Strange::ERROR
        colors[:error].call(message)
      when Strange::WARNING
        colors[:warning].call(message)
      when Strange::NOTICE
        colors[:notice].call(message)
      when Strange::INFO
        colors[:info].call(message)
      when Strange::DEBUG
        colors[:debug].call(message)
      end
    end
  end
end
