# Tempeh

Tasty Ruby Templates

## Description

Tempeh is an opininated template engine for rendering html. It steals
most of its ideas from [Mote](https://github.com/soveran/mote)
and the [Herb](https://github.com/frodsan/herb) fork. The motivation for
a new library is the different rendering API that is designed
for lazily binding a context with instance_eval for use with view components.

## Installation

`gem install tempeh`

## Example

```ruby
# ./templates/eat.tempeh
#
# % if hungry? %
#  Eat {{ food }}!
# % end %

require 'tempeh'

class View
  include Tempeh::Helpers

  def initialize(food)
    @food = food
  end

  def food
    @food
  end

  def hungry?
    true
  end
end

View.new('Tempeh').render('./templates/eat.tempeh') # Eat Tempeh!
```

## API

### Templates

`% code %`: Ruby to be evaluated but not outputted.

`{{ code }}`: Ruby that gets outputted as an escaped string. Safe for user input.

`{{& code }}`: Ruby that gets outputted as an unescaped string. Useful for rendering partials and other content that is guarenteed to be safe.

### Module Methods

`cache`: Hash of compiled templates, populated by the `render` helper.

`compile`: Creates a proc from the the given string.

`escape`: HTML escapes the given string.

### Helpers

`render`: instance_eval's a template found at a file path. Saves the compiled template in `Tempeh::cache` for reuse.
