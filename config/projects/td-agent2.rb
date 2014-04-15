require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "td-agent"

replaces        "td-agent"
install_path    "/opt/td-agent"
build_version   "1.1.19"
build_iteration 0

# creates required build directories
dependency "preparation"

# td-agent dependencies/components
dependency "td-agent"

# version manifest file
dependency "version-manifest"

pkg_type = package_types.first
gem_dir_version = "2.1.0"

# copy pre/post scripts into omnibus path
FileUtils.mkdir_p(package_scripts_path)
Dir.glob(File.join(package_scripts_path, '*')).each { |f|
  FileUtils.rm_f(f) if File.file?(f)
}
Dir.glob(File.join('templates', 'package-scripts', 'td-agent', pkg_type, '*')).each { |f|
  FileUtils.copy(f, package_scripts_path)
}

# copy init.d file
initd_path = File.join(files_path, 'etc', 'init.d')
FileUtils.mkdir_p(initd_path)
FileUtils.copy(File.join('templates', 'etc', 'init.d', pkg_type, 'td-agent'), initd_path)

# setup td and td-agent scripts
td_bin_path = File.join(install_path, 'usr', 'bin', 'td')
FileUtils.mkdir_p(File.dirname(td_bin_path))
File.open(td_bin_path, 'w', 0755) { |f|
  f.write(ERB.new(File.read(File.join('templates', 'usr', 'bin', 'td.erb'))).result(binding))
}

td_agent_sbin_path = File.join(install_path, 'usr', 'sbin', 'td-agent')
FileUtils.mkdir_p(File.dirname(td_agent_sbin_path))
File.open(td_agent_sbin_path, 'w', 0755) { |f|
  f.write(ERB.new(File.read(File.join('templates', 'usr', 'sbin', 'td-agent.erb'))).result(binding))
}

FileUtils.remove_entry_secure(File.join(install_path, 'etc'), true)
FileUtils.cp_r(File.join(files_path, 'etc'), install_path)

exclude "\.git*"
exclude "bundler\/git"
