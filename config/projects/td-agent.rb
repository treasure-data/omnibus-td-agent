require 'fileutils'

name "td-agent"
maintainer "Treasure Data, Inc"
homepage "treasuredata.com"

pkg_type = package_types.first
install_path_dir = if machine == 'x86_64' && pkg_type == 'rpm' # keep backward compatibility
                     '/usr/lib64/fluent'
                   else
                     '/usr/lib/fluent'
                   end

replaces        "td-agent"
install_path    install_path_dir
build_version   "1.1.19"
build_iteration 1

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

# fpm doesn't support missingok yet?
#config_file "#{install_path}/etc/td-agent/td-agent.conf"
extra_package_file "#{install_path}/etc/td-agent/td-agent.conf.tmpl"
extra_package_file "#{install_path}/etc/td-agent/prelink.conf.d/td-agent.prelink.conf"
extra_package_file "#{install_path}/etc/td-agent/logrotate.d/td-agent.logrotate"
extra_package_file "#{install_path}/etc/init.d/td-agent"

exclude "\.git*"
exclude "bundler\/git"
