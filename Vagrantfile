# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant'

if Vagrant::VERSION.to_f < 1.5
  raise "The Omnibus Build Lab only supports Vagrant >= 1.5.0"
end

host_project_path = File.expand_path('..', __FILE__)
project_name = 'td-agent'
host_name = "#{project_name}-omnibus-build-lab"
bootstrap_chef_version = '12.10.24'

Vagrant.configure('2') do |config|
  #config.vm.hostname = "#{project_name}-omnibus-build-lab"
  use_nfs = false
  chef_version = bootstrap_chef_version

  %w{
    ubuntu-10.04
    ubuntu-10.04-i386
    ubuntu-12.04
    ubuntu-12.04-i386
    ubuntu-14.04
    ubuntu-14.04-i386
    ubuntu-16.04
    debian-7.10
    debian-8.4
    centos-5.11
    centos-5.11-i386
    centos-6.7
    centos-6.7-i386
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

      c.vm.box = "opscode-#{platform}"
      c.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{platform}_chef-provisionerless.box"
      c.omnibus.chef_version = chef_version
      c.vm.provider :virtualbox do |vb|
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

      c.vm.provision :shell, :privileged => false, :inline => <<-OMNIBUS_BUILD
        #{export_gcc}
        export PATH="/opt/omnibus-toolchain/embedded/bin/:$PATH"
        sudo mkdir -p /opt/#{project_name}
        sudo chown #{project_build_user} /opt/#{project_name}
        cd #{guest_project_path}
        bundle install --path=/home/#{project_build_user}/.bundler
        bundle exec omnibus build #{project_name}2
      OMNIBUS_BUILD
    end # config.vm.define.platform
  end # each_with_index

  config.vm.define 'amazon' do |c|
    project_build_user = 'ec2-user'
    guest_project_path = "/home/#{project_build_user}/#{File.basename(host_project_path)}"

    # Amazon Linux doesn't have SELinux so it should be removed from Omnibus run_list.
    chef_run_list = ['recipe[yum-epel::default]'] + ['omnibus::_common', 'omnibus::_bash', 'omnibus::_cacerts', 'omnibus::_ccache',
      'omnibus::_chruby', 'omnibus::_compile', 'omnibus::_ruby', 'omnibus::_git', 'omnibus::_github', 'omnibus::_openssl',
      'omnibus::_packaging', 'omnibus::_rsync', 'omnibus::_xml', 'omnibus::_yaml', 'omnibus::_environment'].map { |r|
       "recipe[#{r}]"
    }

    c.vm.box = "dummy"
    c.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
    c.omnibus.chef_version = chef_version
    c.vm.provider :aws do |aws, override|
      aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
      aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
      aws.keypair_name = "td-agent-build"

      aws.ami = "ami-08111162"
      aws.instance_type = 'm3.large'
      aws.tags = {'Name' => 'td-agent-build'}
      aws.security_groups = ['td-agent-build']
      aws.user_data  =  "#!/bin/bash\nsed -i -e 's/^Defaults.*requiretty/# Defaults requiretty/g' /etc/sudoers"
      aws.block_device_mapping = [{'DeviceName' => '/dev/xvda', 'Ebs.VolumeSize' => 20}]

      override.ssh.username = project_build_user
      override.ssh.private_key_path = ENV["AWS_SSH_KEY_PATH"]
      override.ssh.pty = true
    end

    config.berkshelf.enabled = true
    config.ssh.forward_agent = true
    config.vm.synced_folder '.', '/vagrant', :id => 'vagrant-root', :nfs => use_nfs
    config.vm.synced_folder host_project_path, guest_project_path, :nfs => use_nfs

    config.vm.provision :chef_solo do |chef|
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

    config.vm.provision :shell, :privileged => true, :inline => <<-REMOVE_OMNIBUS
      rpm -ev #{project_name} || true
      rm -rf /opt/#{project_name} || true
    REMOVE_OMNIBUS

    config.vm.provision :shell, :privileged => false, :inline => <<-OMNIBUS_BUILD
      export PATH="/opt/omnibus-toolchain/embedded/bin/:$PATH"
      sudo mkdir -p /opt/#{project_name}
      sudo chown #{project_build_user} /opt/#{project_name}
      cd #{guest_project_path}
      bundle install --path=/home/#{project_build_user}/.bundler
      bundle exec omnibus build #{project_name}2
    OMNIBUS_BUILD
  end # config.vm.define.platform
end # Vagrant.configure
