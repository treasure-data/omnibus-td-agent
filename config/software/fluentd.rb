name "fluentd"

# Note: In order to update the Fluentd version, please update both here and also the fluentd versions in
# https://github.com/GoogleCloudPlatform/fluent-plugin-google-cloud/blob/master/fluent-plugin-google-cloud.gemspec
# and
# https://github.com/GoogleCloudPlatform/google-fluentd/blob/master/windows-installer/generate_sdl_agent_exe.ps1
#
# fluentd v1.13.3.
default_version '12de3b5a260a174fe4a419036d6e2b2e18fe7497'

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
