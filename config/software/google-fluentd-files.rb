name "google-fluentd-files"
#version '' # git ref

dependency "google-fluentd"

always_build true

# This software setup google-fluentd related files, e.g. etc files.
# Separating file into google-fluentd.rb and google-fluentd-files.rb is for speed up package building

build do
  block do
    # setup related files
    pkg_type = project.packager.id.to_s
    install_path = project.install_dir # for ERB
    gem_dir_version = "2.1.0"

    # copy pre/post scripts into omnibus path (./package-scripts/google-fluentdN)
    FileUtils.mkdir_p(project.package_scripts_path)
    Dir.glob(File.join(project.package_scripts_path, '*')).each { |f|
      FileUtils.rm_f(f) if File.file?(f)
    }
    Dir.glob(File.join('templates', 'package-scripts', 'google-fluentd', pkg_type, '*')).each { |f|
      package_script = File.join(project.package_scripts_path, File.basename(f))
      File.open(package_script, 'w', 0755) { |fw|
        fw.write(ERB.new(File.read(f)).result(binding))
      }
    }

    # setup plist / init.d file
    if ['mac_pkg', 'mac_dmg'].include?(pkg_type)
      google_fluentd_plist_path = File.join(install_path, 'google-fluentd.plist')
      File.open(google_fluentd_plist_path, 'w', 0755) { |f|
        f.write(ERB.new(File.read(File.join('templates', 'google-fluentd.plist.erb'))).result(binding))
      }
    else
      initd_path = File.join(project.resources_path, 'etc', 'init.d')
      FileUtils.mkdir_p(initd_path)
      File.open(File.join(initd_path, 'google-fluentd'), 'w', 0755) { |fw|
        fw.write(ERB.new(File.read(File.join('templates', 'etc', 'init.d', pkg_type, 'google-fluentd'))).result(binding))
      }
    end

    # setup td and google-fluentd scripts
    td_bin_path = File.join(install_path, 'usr', 'bin', 'td')
    FileUtils.mkdir_p(File.dirname(td_bin_path))
    File.open(td_bin_path, 'w', 0755) { |f|
      f.write(ERB.new(File.read(File.join('templates', 'usr', 'bin', 'td.erb'))).result(binding))
    }

    ['google-fluentd', 'google-fluentd-gem'].each { |command|
      google_fluentd_sbin_path = File.join(install_path, 'usr', 'sbin', command)
      FileUtils.mkdir_p(File.dirname(google_fluentd_sbin_path))
      File.open(google_fluentd_sbin_path, 'w', 0755) { |f|
        f.write(ERB.new(File.read(File.join('templates', 'usr', 'sbin', "#{command}.erb"))).result(binding))
      }
    }

    FileUtils.remove_entry_secure(File.join(install_path, 'etc'), true)
    FileUtils.cp_r(File.join(project.resources_path, 'etc'), install_path)
  end
end
