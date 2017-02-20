name "fluentd"
#default_version 'aee8086e9fcd3b45fa11b83e866fd758cb79bffb'
#default_version 'v0.14.11'
default_version 'master' # https://github.com/fluent/fluentd/issues/1449

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
