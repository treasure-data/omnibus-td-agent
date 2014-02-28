
name "td-agent"
maintainer "Treasure Data, Inc"
homepage "treasuredata.com"

replaces        "td-agent"
install_path    "/opt/td-agent"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

# creates required build directories
dependency "preparation"

# td-agent dependencies/components
dependency "td-agent"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
