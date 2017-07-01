require_relative '../lib/tempeh'

setup do
  Tempeh.new
end

test "parsing" do |t|
  # empty lines
  template = t.parse("\n\n \n")

  assert_equal "\n\n \n", template.render

  # quotes
  template = t.parse("'foo' 'bar' 'baz'")

  assert_equal "'foo' 'bar' 'baz'", template.render

  # block expressions
  template = t.parse("% if true %yes% else %no% end %")

  assert_equal "yes", template.render

  # string expressions
  template = t.parse("{ 'Hello' }")

  assert_equal "Hello", template.render

  # nil string expressions
  template = t.parse("{ nil }")

  assert_equal "", template.render

  # render with context
  context = Struct.new(:foo).new('bar')

  template = t.parse("{ foo }")

  assert_equal "bar", template.render(context)

  # render with args
  template = t.parse("{ args[:foo] }")

  assert_equal "bar", template.render(foo: "bar")
end

setup do
  Tempeh.new(blk_open: "^", blk_close: ")", str_open: "[$", str_close: "]]")
end

test "custom delimiters" do |t|
  # block expressions
  template = t.parse("^ if true )yes^ else )no^ end )")

  assert_equal "yes", template.render

  # string expressions
  template = t.parse("[$ 'Hello' ]]")

  assert_equal "Hello", template.render
end
