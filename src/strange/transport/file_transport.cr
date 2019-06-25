require "./transport"

class Strange
  class FileTransport < Transport

    # Whether to overwrite the file. If this is false all logs wi
    property file : String

    def initialize(@file : String, level : Strange::Level? = nil, formatter : Strange::Formatter? = nil)
      @level = level || Strange.level
      @formatter = formatter || BasicFormatter.new
    end

    def log(message : String, level : Strange::Level)
      formatted = @formatter.format(message, level)
      File.write(@file, formatted, mode: "a+")
    end

  end
end
