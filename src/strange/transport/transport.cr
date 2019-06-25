require "../formatter/basic_formatter"

class Strange
  abstract class Transport
    property level : Strange::Level
    property formatter : Strange::Formatter

    def initialize(level : Strange::Level? = nil, formatter : Strange::Formatter? = nil)
      @level = level || Strange.level
      @formatter = formatter || BasicFormatter.new
    end

    abstract def log(message : String, level : Strange::Level)

    def format(text : String, level : Logger::Level)
      @formatter.format(text, level)
    end
  end
end
