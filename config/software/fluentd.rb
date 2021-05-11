name "fluentd"
# fluentd v1.12.3.
default_version 'b6e76c09d60ee866de6470f2bdd2551e7c8591d3'

dependency "ruby"
#dependency "bundler"

source :git => 'https://github.com/fluent/fluentd.git'
relative_path "fluentd"

build do
  Dir.glob(File.expand_path(File.join(Omnibus::Config.project_root, 'core_gems', '*.gem'))).sort.each { |gem_path|
    gem "install --no-document #{gem_path}"
  }
  rake "build"
  gem "install --no-document pkg/fluentd-*.gem"
end
