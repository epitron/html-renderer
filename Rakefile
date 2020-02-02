gem = eval(File.read '.gemspec')

gemfile = "#{gem.name}-#{gem.version}.gem"

task :build do
  system "gem build .gemspec"
  system "mkdir pkg/" unless File.directory? "pkg"
  system "mv #{gemfile} pkg/"
end
 
task :release => :build do
  system "gem push pkg/#{gemfile}"
end

task :gem => :build

task :install => :build do
  system "gem install pkg/#{gemfile}"
end
