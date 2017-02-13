name "fluentd"
#default_version 'aee8086e9fcd3b45fa11b83e866fd758cb79bffb'
#default_version 'v0.14.11'
default_version '92dbf54d85fba22e86b015853875e6116d73eabc' # https://github.com/fluent/fluentd/issues/1449

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
