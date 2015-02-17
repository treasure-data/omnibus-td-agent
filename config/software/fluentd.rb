name "fluentd"
default_version 'b398bd605876883a60496495bb46e26d33fe6f43'

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
