name "fluentd"

# Note: In order to update the Fluentd version, please update both here and also the fluentd version in
# https://github.com/GoogleCloudPlatform/fluent-plugin-google-cloud/blob/master/fluent-plugin-google-cloud.gemspec.
# fluentd v1.11.2.
default_version '3dde9396ee30263980ad2655fc78197b41d2b3fd'

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
