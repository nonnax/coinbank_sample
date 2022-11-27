# Rakefile
# ---------cut-----------

task default: %w[build]

desc "Bundle install dependencies"
task :bundle do
  sh "bundle install"
end

desc "Build the coinbank.gem file"
task :build do
  sh "gem build coinbank.gemspec"
end

desc "install coinbank-x.x.x.gem"
task install: %w[build] do
  sh "gem install $(ls coinbank-*.gem)"
end
