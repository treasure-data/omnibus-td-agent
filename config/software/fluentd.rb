name "fluentd"
default_version 'f6aa9a4b275e4e9885bb912bcf0e930966d8e246'

dependency "ruby"
#dependency "bundler"

source :git => 'https://github.com/fluent/fluentd.git'
relative_path "fluentd"

build do
  Dir.glob(File.expand_path(File.join(Omnibus::Config.project_root, 'core_gems', '*.gem'))).sort.each { |gem_path|
    gem "install --no-ri --no-rdoc #{gem_path}"
  }
  rake "build"
  gem "install --no-ri --no-rdoc pkg/fluentd-*.gem"
end
