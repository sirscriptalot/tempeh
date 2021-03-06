module Tempeh
  VERSION = "0.3.0"

  BLK_OPEN = "%"

  BLK_CLOSE = "%"

  RAW_OPEN = "{{&"

  RAW_CLOSE = "}}"

  STR_OPEN = "{{"

  STR_CLOSE = "}}"

  PATTERN = /
    (?<!\\)(#{BLK_OPEN})\s+(.*?)\s+#{BLK_CLOSE} | # Multiline blocks.
    (?<!\\)(#{RAW_OPEN})(.*?)#{RAW_CLOSE}       | # Evaluated as a string, unescaped
    (?<!\\)(#{STR_OPEN})(.*?)#{STR_CLOSE}         # Evaluated as a string, escaped.
  /mx

  HTML_ESCAPE = {
    "&" => "&amp;",
    ">" => "&gt;",
    "<" => "&lt;",
    '"' => "&#39;",
    "'" => "&#34;"
  }.freeze

  UNSAFE = /[&"'><]/

  class << self
    def cache
      @cache ||= {}
    end

    def compile(str)
      terms = str.split(PATTERN)

      parts = "proc { |args| __o = '';"

      while (term = terms.shift)
        case term
        when BLK_OPEN then parts << "#{terms.shift}\n"
        when RAW_OPEN then parts << "__o << (#{terms.shift}).to_s\n"
        when STR_OPEN then parts << "__o << Tempeh.escape((#{terms.shift}).to_s)\n"
        else               parts << "__o << #{term.dump}\n"
        end
      end

      parts << "__o; }"

      eval(parts)
    end

    def escape(str)
      str.gsub(UNSAFE, HTML_ESCAPE)
    end
  end

  def test
    b = binding
    p = proc { b.eval("a = 22") }
    p.call
    puts a
  end

  module Helpers
    DEFAULT_ARGS = {}.freeze

    def render(path, args = DEFAULT_ARGS)
      instance_exec args, &tempeh_template_for(path)
    end

    def tempeh_template_for(path)
      Tempeh.cache[path] ||= Tempeh.compile(File.read(path))
    end
  end
end
