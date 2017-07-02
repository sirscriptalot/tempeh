require_relative '../lib/tempeh'

test 'empty lines' do
  template = Tempeh.new("\n\n \n")

  assert_equal "\n\n \n", template.render
end

test 'quotes' do
  template = Tempeh.new("'foo' 'bar' 'baz'")

  assert_equal "'foo' 'bar' 'baz'", template.render
end

test 'block expressions' do
  template = Tempeh.new("% if true %yes% else %no% end %")

  assert_equal "yes", template.render
end

test 'string expressions' do
  template = Tempeh.new("{ 'Hello' }")

  assert_equal "Hello", template.render
end

test 'escapes string expressions' do
  template = Tempeh.new(%q({ %q(<>&"') }))

  assert_equal "&lt;&gt;&amp;&#39;&#34;", template.render
end

test 'nil string expressions' do
  template = Tempeh.new("{ nil }")

  assert_equal "", template.render
end

test 'allows escaping expressions' do
  template = Tempeh.new('\{ nil }\% hello %')

  assert_equal '\{ nil }\% hello %', template.render
end

test 'render with context' do
  context = Struct.new(:foo).new('bar')

  template = Tempeh.new("{ foo }")

  assert_equal "bar", template.render(context)
end

test 'render with args' do
  template = Tempeh.new("{ args[:foo] }")

  assert_equal "bar", template.render(foo: "bar")
end
