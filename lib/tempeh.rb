class Tempeh
  VERSION = "0.1.0"

  BLK_OPEN = '%'

  BLK_CLOSE = '%'

  STR_OPEN = '{'

  STR_CLOSE = '}'

  PATTERN = /
    (?<!\\)(#{BLK_OPEN})\s+(.*?)\s+#{BLK_CLOSE} | # Multiline Ruby blocks.
    (?<!\\)(#{STR_OPEN})(.*?)#{STR_CLOSE}         # Ruby to be evaluated a string.
  /mx

  HTML_ESCAPE = {
    "&" => "&amp;",
    ">" => "&gt;",
    "<" => "&lt;",
    '"' => "&#39;",
    "'" => "&#34;",
  }.freeze

  UNSAFE = /[&"'><]/

  class << self
    def compile(str)
      terms = str.split(PATTERN)
      parts = "proc do |args = {}, __o = ''|"

      while (term = terms.shift)
        case term
        when BLK_OPEN then parts << terms.shift << "\n"
        when STR_OPEN then parts << "__o << Tempeh.escape((" << terms.shift << ").to_s)\n"
        else               parts << "__o << " << term.dump << "\n"
        end
      end

      parts << "__o; end"

      eval(parts)
    end

    def escape(str)
      str.gsub(UNSAFE, HTML_ESCAPE)
    end
  end

  def initialize(str)
    @code = Tempeh.compile(str)
  end

  def render(context = nil, **args)
    context.instance_exec(args, &@code)
  end
end
