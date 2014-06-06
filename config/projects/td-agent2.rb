require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent2"
package_name "td-agent"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "Treasure Agent: A data collector for Treasure Data"

install_path    "/opt/td-agent"
build_version   "2.0.0"
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
