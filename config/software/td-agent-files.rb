name "td-agent-files"
#version '' # git ref

dependency "td-agent"

always_build true

# This software setup td-agent related files, e.g. etc files.
# Separating file into td-agent.rb and td-agent-files.rb is for speed up package building

build do
  block do
    # setup related files
    pkg_type = project.package_types.first
    install_path = project.install_path # for ERB
    gem_dir_version = "2.1.0"

    # copy pre/post scripts into omnibus path
    FileUtils.mkdir_p(project.package_scripts_path)
    Dir.glob(File.join(project.package_scripts_path, '*')).each { |f|
      FileUtils.rm_f(f) if File.file?(f)
    }
    Dir.glob(File.join('templates', 'package-scripts', 'td-agent', pkg_type, '*')).each { |f|
      package_script = File.join(project.package_scripts_path, File.basename(f))
      File.open(package_script, 'w', 0755) { |fw|
        fw.write(ERB.new(File.read(f)).result(binding))
      }
    }

    # copy init.d file
    initd_path = File.join(project.files_path, 'etc', 'init.d')
    FileUtils.mkdir_p(initd_path)
    File.open(File.join(initd_path, 'td-agent'), 'w', 0755) { |fw|
      fw.write(ERB.new(File.read(File.join('templates', 'etc', 'init.d', pkg_type, 'td-agent'))).result(binding))
    }

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
    FileUtils.cp_r(File.join(project.files_path, 'etc'), install_path)
  end
end
