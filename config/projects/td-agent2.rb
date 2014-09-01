require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "Treasure Agent: A data collector for Treasure Data"

install_dir     "/opt/td-agent"
build_version   "2.1.0"
build_iteration 0

# creates required build directories
dependency "preparation"

# td-agent dependencies/components
dependency "td-agent"
dependency "td-agent-files"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
