require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "td-agent"

pkg_type = package_types.first
install_path_dir = if machine == 'x86_64' && pkg_type == 'rpm' # keep backward compatibility
                     '/usr/lib64/fluent'
                   else
                     '/usr/lib/fluent'
                   end

replaces        "td-agent"
install_path    install_path_dir
build_version   "1.1.19"
build_iteration 0

# creates required build directories
dependency "preparation"

# td-agent dependencies/components
dependency "td-agent"

# version manifest file
dependency "version-manifest"

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

# monck.patch for rpm.erb
case pkg_type
when 'rpm'
  old_template = File.join(File.expand_path(File.join(Gem.bin_path('fpm', 'fpm'), '..', '..', 'templates')), 'rpm.erb')
  FileUtils.copy(File.join('templates', 'rpm.erb'), old_template)
end

# setup td and td-agent scripts
td_bin_path = File.join(install_path_dir, 'usr', 'bin', 'td')
FileUtils.mkdir_p(File.dirname(td_bin_path))
File.open(td_bin_path, 'w', 0755) { |f|
  f.write(ERB.new(File.read(File.join('templates', 'usr', 'bin', 'td.erb'))).result(binding))
}

td_agent_sbin_path = File.join(install_path_dir, 'usr', 'sbin', 'td-agent')
FileUtils.mkdir_p(File.dirname(td_agent_sbin_path))
File.open(td_agent_sbin_path, 'w', 0755) { |f|
  f.write(ERB.new(File.read(File.join('templates', 'usr', 'sbin', 'td-agent.erb'))).result(binding))
}

exclude "\.git*"
exclude "bundler\/git"
