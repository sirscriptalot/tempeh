require_relative '../lib/tempeh'

test 'empty lines' do
  template = Tempeh.compile("\n\n \n")

  assert_equal "\n\n \n", template.call
end

test 'quotes' do
  template = Tempeh.compile("'foo' 'bar' 'baz'")

  assert_equal "'foo' 'bar' 'baz'", template.call
end

test 'block expressions' do
  template = Tempeh.compile("% if true %yes% else %no% end %")

  assert_equal "yes", template.call
end

test 'unescaped string expressions' do
  template = Tempeh.compile(%q({{& %q(<>&"') }}))

  assert_equal %q(<>&"'), template.call
end

test 'escaped string expressions' do
  template = Tempeh.compile(%q({{ %q(<>&"') }}))

  assert_equal "&lt;&gt;&amp;&#39;&#34;", template.call
end

test 'nil string expressions' do
  template = Tempeh.compile("{{ nil }}")

  assert_equal "", template.call
end

test 'allows escaping expressions' do
  template = Tempeh.compile('\{{ nil }}\% hello %')

  assert_equal '\{{ nil }}\% hello %', template.call
end

test 'contextual rendering' do
  context  = Struct.new(:foo).new('bar')
  template = Tempeh.compile("{{ foo }}")

  assert_equal "bar", context.instance_eval(&template)
end

test 'passes optional `args` variable' do
  template = Tempeh.compile("{{ args[:foo] }}")

  assert_equal "bar", instance_exec({ foo: "bar" }, &template)
end

class View
  include Tempeh::Helpers

  def initialize(name)
    @name = name
  end

  def name
    @name
  end
end

setup do
  View.new('steve')
end

test 'helpers' do |view|
  path = './examples/basic.tempeh'

  assert Tempeh.cache[path].nil?, 'template is already cached'

  assert_equal "\n\nstevestevesteve", view.render(path)

  assert Tempeh.cache[path], 'template was not cached'

  assert_equal "\n\nnotstevenotstevenotsteve", view.render(path, name: 'notsteve')
end
