require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "Treasure Agent: A data collector for Treasure Data"

install_dir     "/opt/td-agent"
build_version   "2.2.1"
build_iteration 0

# creates required build directories
dependency "preparation"

override :ruby, :version => '2.1.5'
override :zlib, :version => '1.2.8'
override :rubygems, :version => '2.2.1'
override :postgresql, :version => '9.3.5'
# CentOS7 needs latest liblzma to build pg and some gems
if ohai['platform_family'] == 'rhel' && ohai['platform_version'].split('.').first.to_i == 7
  override :liblzma, :version => '5.1.2alpha'
end
# workaround until https://github.com/chef/omnibus-software/pull/473 is live.
override :ncurses, :version => '5.9'

# td-agent dependencies/components
dependency "td-agent"
dependency "td-agent-files"
dependency "td"
dependency "td-agent-ui"
dependency "td-agent-cleanup"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"

compress :dmg do
end
