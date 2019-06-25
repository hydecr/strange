require "json"
require "./formatter"

class Strange
  class JSONFormatter < Formatter

    property indent : Bool

    def initialize(indent : Bool? = nil)
      @indent = indent.nil? ? false : indent
    end

    def format(text : String, level : Strange::Level)
      hash = {
        "severity" => level.to_s,
        "message" => text,
        "time" => Time::Format::ISO_8601_DATE_TIME.format(Time.now)
      }

      if @indent
        hash.to_pretty_json
      else
        hash.to_json
      end
    end

  end
end
