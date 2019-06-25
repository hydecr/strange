require "./formatter"

class Strange
  # A very basic formatter that formats messages as
  # `[LEVEL  ] - Message`
  class BasicFormatter < Formatter

    def format(text : String, level : Strange::Level)
      level = "[" + ("%-7.7s" % level.to_s) + "]"
      "#{level} - #{text}"
    end

  end
end
