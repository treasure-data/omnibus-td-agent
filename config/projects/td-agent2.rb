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
