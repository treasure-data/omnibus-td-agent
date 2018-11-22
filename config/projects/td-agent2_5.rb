require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "Treasure Agent: A data collector for Treasure Data"
license "Apache-2.0"
license_file "LICENSE"

install_dir     "/opt/td-agent"
build_version   "2.5.0"
build_iteration 0

# creates required build directories
dependency "preparation"

override :ruby, :version => '2.5.3' # This override version is used for gem_dir_version. See td-agent-files.rb
override :zlib, :version => '1.2.11'
override :jemalloc, :version => '5.1.0'
override :rubygems, :version => '2.6.14'
override :postgresql, :version => '9.6.9'
override :fluentd, :version => 'c485bbfa9a101ebe678545a377aecd1cfcf4a5e6' # v0.12.43

# td-agent dependencies/components
dependency "td-agent"
dependency "td-agent-files"
dependency "td"
dependency "td-agent-ui"
dependency "td-agent-cleanup"

# version manifest file
dependency "version-manifest"

case ohai["os"]
when "linux"
  case ohai["platform_family"]
  when "debian"
    runtime_dependency "lsb-base"
  when "rhel"
    runtime_dependency "initscripts"
    runtime_dependency "redhat-lsb-core"
  end
end

exclude "\.git*"
exclude "bundler\/git"

compress :dmg do
end
