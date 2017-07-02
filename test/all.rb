require_relative '../lib/tempeh'

test do |t|
  # empty lines
  template = Tempeh.new("\n\n \n")

  assert_equal "\n\n \n", template.render

  # quotes
  template = Tempeh.new("'foo' 'bar' 'baz'")

  assert_equal "'foo' 'bar' 'baz'", template.render

  # block expressions
  template = Tempeh.new("% if true %yes% else %no% end %")

  assert_equal "yes", template.render

  # string expressions
  template = Tempeh.new("{ 'Hello' }")

  assert_equal "Hello", template.render

  # nil string expressions
  template = Tempeh.new("{ nil }")

  assert_equal "", template.render

  # allows escaping expressions
  template = Tempeh.new('\{ nil }\% hello %')

  assert_equal '\{ nil }\% hello %', template.render

  # render with context
  context = Struct.new(:foo).new('bar')

  template = Tempeh.new("{ foo }")

  assert_equal "bar", template.render(context)

  # render with args
  template = Tempeh.new("{ args[:foo] }")

  assert_equal "bar", template.render(foo: "bar")
end
