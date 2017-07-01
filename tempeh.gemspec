require_relative "./lib/tempeh"

Gem::Specification.new do |s|
  s.name     = "tempeh"
  s.summary  = "Tempeh"
  s.version  = Tempeh::VERSION
  s.authors  = ["Steve Weiss"]
  s.email    = ["weissst@mail.gvsu.edu"]
  s.homepage = "https://github.com/sirscriptalot/tempeh"
  s.license  = "MIT"
  s.files    = `git ls-files`.split("\n")

  s.add_development_dependency "cutest"
end
