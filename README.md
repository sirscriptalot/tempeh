Tempeh
======

Tasty Ruby Templates

Description
-----------

Tempeh is an opininated template engine for rendering html. It steals
most of its ideas from Mote and also the Herb fork. That means it is a
small layer on top of Ruby that escapes strings by default. The render API
differs from both, as the context the template gets rendered with does not
get "compiled" with the template, instead the context gets lazily executed
each time when passed to `#render`.

Usage
-----

```ruby
template = Tempeh.new("
  % if hungry? %
    Eat { args[:food] }!
  % end %
")

module Steve
  def self.hungry?
    true # always...
  end
end

template.render(Steve, food: 'Tempeh') # Eat Tempeh!
```
