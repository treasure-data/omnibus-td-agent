# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant'

if Vagrant::VERSION.to_f < 1.5
  raise "The Omnibus Build Lab only supports Vagrant >= 1.5.0"
end

host_project_path = File.expand_path('..', __FILE__)
guest_project_path = "/home/vagrant/#{File.basename(host_project_path)}"
project_name = 'td-agent'
host_name = "#{project_name}-omnibus-build-lab"
bootstrap_chef_version = '11.12.4'

Vagrant.configure('2') do |config|
  #config.vm.hostname = "#{project_name}-omnibus-build-lab"

  %w{
    ubuntu-10.04
    ubuntu-10.04-i386
    ubuntu-12.04
    ubuntu-12.04-i386
    centos-5.10
    centos-5.10-i386
    centos-6.5
    centos-6.5-i386
  }.each_with_index do |platform, index|
    use_nfs = false
    chef_version = bootstrap_chef_version

    config.vm.define platform do |c|
      chef_run_list = []

      case platform
      when /^freebsd/
        raise "Not supported yet: FreeBSD"
      when /^ubuntu/
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
          '--cpus', '2'
        ]
      end

      # Shared configuraiton

      chef_run_list << 'recipe[omnibus::default]'

      config.berkshelf.enabled = true
      config.ssh.forward_agent = true
      config.vm.synced_folder '.', '/vagrant', :id => 'vagrant-root', :nfs => use_nfs
      config.vm.synced_folder host_project_path, guest_project_path, :nfs => use_nfs

      c.vm.provision :chef_solo do |chef|
        chef.synced_folder_type = "nfs" if use_nfs
        chef.json = {
          'omnibus' => {
            'build_user' => 'vagrant',
            'build_dir' => guest_project_path,
            'ruby_version' => '2.1.2',
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
        sudo mkdir -p /opt/#{project_name}
        sudo chown vagrant /opt/#{project_name}
        cd #{guest_project_path}
        bundle install --path=/home/vagrant/.bundler
        bundle exec omnibus build project #{project_name}2
      OMNIBUS_BUILD
    end # config.vm.define.platform
  end # each_with_index
end # Vagrant.configure
