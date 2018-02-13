name "fluentd"
# fluentd v0.14.25
default_version '363b1af858aab34d90d9a98d63107b1206afd141'

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
