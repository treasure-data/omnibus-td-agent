require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "Treasure Agent: A data collector for Treasure Data"

install_dir     "/opt/td-agent"
build_version   "3.0.0"
build_iteration 0

# creates required build directories
dependency "preparation"

if windows?
  override :ruby, :version => '2.3.3'
else
  override :ruby, :version => '2.4.0'
end
override :zlib, :version => '1.2.8'
override :rubygems, :version => '2.6.7'
override :postgresql, :version => '9.5.5'
override :fluentd, :version => '0d6a3276b790951dedcfcacf870422a08b27adfe' # v0.14.11

# td-agent dependencies/components
dependency "td-agent"
dependency "td-agent-files"
dependency "td"
#dependency "td-agent-ui" # fluentd-ui doesn't work with ruby 2.4 because some gems depend on json 1.8
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

package :msi do
  upgrade_code "76dcb0b2-81ad-4a07-bf3b-1db567594171"
end
