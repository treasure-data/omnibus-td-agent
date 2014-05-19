require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent2"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "Treasure Agent: A data collector for Treasure Data"

replaces        "td-agent"
install_path    "/opt/td-agent"
build_version   "1.0.0"
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
