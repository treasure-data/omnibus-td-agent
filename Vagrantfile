# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant'

if Vagrant::VERSION.to_f < 1.5
  raise "The Omnibus Build Lab only supports Vagrant >= 1.5.0"
end

td_agent_version = (ENV["BUILD_TD_AGENT_VERSION"] || 3).to_s
host_project_path = File.expand_path('..', __FILE__)
project_name = 'td-agent'
host_name = "#{project_name}-omnibus-build-lab"
bootstrap_chef_version = '12.14.89'

Vagrant.configure('2') do |config|
  #config.vm.hostname = "#{project_name}-omnibus-build-lab"
  use_nfs = false
  chef_version = bootstrap_chef_version

  %w{
    ubuntu-12.04
    ubuntu-12.04-i386
    ubuntu-14.04
    ubuntu-14.04-i386
    ubuntu-16.04
    ubuntu-16.04-i386
    ubuntu-18.04
    debian-8.4
    debian-9.3
    centos-6.9
    centos-6.9-i386
    centos-7.2
  }.each_with_index do |platform, index|
    project_build_user = 'vagrant'
    guest_project_path = "/home/#{project_build_user}/#{File.basename(host_project_path)}"

    config.vm.define platform do |c|
      chef_run_list = []

      case platform
      when /^freebsd/
        raise "Not supported yet: FreeBSD"
      when /^ubuntu/, /^debian/
        chef_run_list << 'recipe[apt::default]'
      when /^centos/
        chef_run_list << 'recipe[yum-epel::default]'
      else
        raise "Unknown platform: #{platform}"
      end

      c.vm.box = "bento/#{platform}"
      c.omnibus.chef_version = chef_version
      c.vm.provider 'virtualbox' do |vb|
        # Give enough horsepower to build without taking all day.
        vb.customize [
          'modifyvm', :id,
          '--memory', '4096',
          '--cpus', '4'
        ]
      end

      # Shared configuraiton

      chef_run_list << 'recipe[omnibus::default]'

      config.berkshelf.enabled = true
      config.ssh.username = 'vagrant'
      config.ssh.password = 'vagrant'
      config.ssh.forward_agent = true
      config.vm.synced_folder '.', '/vagrant', :id => 'vagrant-root', :nfs => use_nfs
      config.vm.synced_folder host_project_path, guest_project_path, :nfs => use_nfs
      if platform == 'ubuntu-14.04-i386'
        config.vbguest.auto_update = true
      else
        config.vbguest.auto_update = false
      end

      c.vm.provision :chef_solo do |chef|
        chef.synced_folder_type = "nfs" if use_nfs
        chef.json = {
          'omnibus' => {
            'build_user' => project_build_user,
            'build_dir' => guest_project_path,
            'ruby_version' => '2.1.8',
            'install_dir' => "/opt/#{project_name}"
          }
        }

        chef.run_list = chef_run_list
      end

      # We have to nuke any chef omnibus packages (used during provisioning) before
      # we build new chef omnibus packages!
      c.vm.provision :shell, :privileged => true, :inline => <<-REMOVE_OMNIBUS
        if command -v dpkg &>/dev/null; then
          dpkg -P #{project_name} || true
        elif command -v rpm &>/dev/null; then
          rpm -ev #{project_name} || true
        fi
        rm -rf /opt/#{project_name} || true
      REMOVE_OMNIBUS

      # it will be resolved after new omnibus cookbook released, 2.3.1 or later.
      if platform.start_with?('centos-5.10')
        c.vm.provision :shell, :privileged => true, :inline => <<-UPDATE_GCC
        yum install gcc44 gcc44-c++
      UPDATE_GCC

        export_gcc = <<-GCC_EXPORT
        export CC="gcc44"
        export CXX="g++44"
      GCC_EXPORT
      else
        export_gcc = ''
      end

      if platform.start_with?('centos-6')
        # ruby 2.4 requires newer autoconf to build
        c.vm.provision :shell, :privileged => true, :inline => <<-UPDATE_AUTOCONF
        wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
        tar xvfvz autoconf-2.69.tar.gz
        cd autoconf-2.69
        ./configure
        make
        make install
      UPDATE_AUTOCONF
      end

      if platform.start_with?('centos-')
        # Need sasl package for rdkafka with SASL
        c.vm.provision :shell, :privileged => true, :inline => <<-INSTALL_SASL
        yum install -y cyrus-sasl-devel cyrus-sasl-lib cyrus-sasl-gssapi
      INSTALL_SASL
      end

      if platform.start_with?('debian-9') || platform.start_with?('ubuntu-18')
        # https://github.com/chef/omnibus-toolchain/issues/73
        c.vm.provision :shell, :privileged => true, :inline => <<-REMOVE_TAR
        rm /opt/omnibus-toolchain/bin/tar
        rm /opt/omnibus-toolchain/bin/gtar
        rm /opt/omnibus-toolchain/embedded/bin/tar
      REMOVE_TAR
      end

      c.vm.provision :shell, :privileged => false, :inline => <<-OMNIBUS_BUILD
        #{export_gcc}
        export PATH="/opt/omnibus-toolchain/embedded/bin/:$PATH"
        sudo mkdir -p /opt/#{project_name}
        sudo chown #{project_build_user} /opt/#{project_name}
        cd #{guest_project_path}
        bundle install --path=/home/#{project_build_user}/.bundler
        bundle exec omnibus build #{project_name}#{td_agent_version}
      OMNIBUS_BUILD
    end # config.vm.define.platform
  end # each_with_index
end # Vagrant.configure
