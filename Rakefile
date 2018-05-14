gem_version = File.read("VERSION").strip
gem_name    = "html-renderer"

task :build do
  system "gem build .gemspec"
end

task :release => :build do
  system "gem push #{gem_name}-#{gem_version}.gem"
end

task :install => :build do
  system "gem install --local #{gem_name}-#{gem_version}.gem"
end

task :pry do
  system "pry --gem"
end

task :default => :spec
