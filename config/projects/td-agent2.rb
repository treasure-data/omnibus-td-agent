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
build_version   "2.3.5"
build_iteration 1

# creates required build directories
dependency "preparation"

override :ruby, :version => '2.1.10' # This override version is used for gem_dir_version. See td-agent-files.rb
override :zlib, :version => '1.2.8'
override :rubygems, :version => '2.6.13'
override :postgresql, :version => '9.3.5'
override :fluentd, :version => 'd5e0a61e06a7cfeb7266b018e77ac74f85c0c06d' # v0.12.40

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
    if ohai["platform_version"][0] == "5"
      runtime_dependency "redhat-lsb"
    else
      runtime_dependency "redhat-lsb-core"
    end
  end
end

exclude "\.git*"
exclude "bundler\/git"

compress :dmg do
end
