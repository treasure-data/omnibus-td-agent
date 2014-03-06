require 'fileutils'

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

# copy pre/post scripts into omnibus path
pkg_type = package_types.first
Dir.glob(File.join(package_scripts_path, pkg_type, '*')).each { |f|
  FileUtils.copy(f, package_scripts_path)
}

# copy init.d file
initd_path = File.join(files_path, 'etc', 'init.d')
FileUtils.copy(File.join(initd_path, pkg_type, 'td-agent'), initd_path)

# fpm doesn't support missingok yet?
#config_file "#{install_path}/etc/td-agent/td-agent.conf"
extra_package_file "#{install_path}/etc/td-agent/td-agent.conf.tmpl"
extra_package_file "#{install_path}/etc/td-agent/prelink.conf.d/td-agent.prelink.conf"
extra_package_file "#{install_path}/etc/td-agent/logrotate.d/td-agent.logrotate"
extra_package_file "#{install_path}/etc/init.d/td-agent"

exclude "\.git*"
exclude "bundler\/git"
