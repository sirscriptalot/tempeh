task :gems do
  sh "mkdir -p .gs"
end

task install: [:gems] do
  sh "gs bundle install --system"
end

task :test do
  sh "gs cutest -r ./test/*.rb"
end
