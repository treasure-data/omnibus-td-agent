name "fluentd"
# fluentd v0.12.29
default_version 'cd458194c949851a2b76c06b994330e964b55cc0'

dependency "ruby"
#dependency "bundler"

source :git => 'https://github.com/fluent/fluentd.git'
relative_path "fluentd"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  Dir.glob(File.expand_path(File.join(Omnibus::Config.project_root, 'core_gems', '*.gem'))).sort.each { |gem_path|
    gem "install --no-ri --no-rdoc #{gem_path}", env: env
  }
  rake "build", env: env
  gem "install --no-ri --no-rdoc pkg/fluentd-*.gem", env: env
end
