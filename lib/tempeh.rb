class Tempeh
  VERSION = "0.1.0"
  BLK_OPEN = "%"
  BLK_CLOSE = "%"
  STR_OPEN = "{"
  STR_CLOSE = "}"

  def initialize(**opts)
    # Allow users to provide custom delimiters for both
    # the block and string expressions.
    @blk_open = opts.fetch(:blk_open, BLK_OPEN)
    @blk_close = opts.fetch(:blk_close, BLK_CLOSE)
    @str_open = opts.fetch(:str_open, STR_OPEN)
    @str_close = opts.fetch(:str_close, STR_CLOSE)

    # Prepare delimiters for use in regexp pattern.
    escaped_blk_open,
    escaped_blk_close,
    escaped_str_open,
    escaped_str_close = [
      @blk_open,
      @blk_close,
      @str_open,
      @str_close
    ].collect { |delimiter| Regexp.escape(delimiter) }

    @pattern = /
      (#{escaped_blk_open})\s+(.*?)\s+#{escaped_blk_close} | # Multiline Ruby blocks.
      (#{escaped_str_open})(.*?)#{escaped_str_close}         # Ruby to be escaped as a string.
    /mx
  end

  def parse(raw, template = Template)
    terms = raw.split(@pattern)
    parts = "proc do |args = {}, __o = ''|"

    while (term = terms.shift)
      case term
      when @blk_open then parts << terms.shift << "\n"
      when @str_open then parts << "__o << (" << terms.shift << ").to_s \n"
      else                parts << "__o << " << term.dump << "\n"
      end
    end

    parts << "__o; end"

    code = eval(parts) # Compile parts into a Proc.

    template.new(code)
  end

  private

  class Template
    def initialize(code)
      @code = code
    end

    # Convenience for executing the code Proc in a given context.
    def render(context = nil, **args)
      context.instance_exec(args, &@code)
    end
  end
end
