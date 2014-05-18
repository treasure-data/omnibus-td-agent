# About

The event collector daemon, for Treasure Data. This daemon collects various types of logs/events via various way, and transfer them to the cloud. For more about Treasure Data, see the [homepage](http://treasuredata.com/), and the [documentation](http://docs.treasuredata.com/).

td-agent is open sourced as [Fluentd project](http://github.com/fluent/). In other words, td-agent is a distribution package of Fluentd.

td-agent package is based on [Omnibus-ruby](https://github.com/opscode/omnibus-ruby)

## Installation

We'll assume you have Ruby 1.9+ and Bundler installed. First ensure all required gems are installed and ready to use:

```shell
$ bundle install --binstubs
```

## Usage

### Build

At first, you should download dependent gems using downloder. This is for avoding broken gem download and reduce the build time on Vagrant.

```shell
$ bin/gem_downloader core_gems.rb
$ bin/gem_downloader plugin_gems.rb
```

Create required directory and add permission

```shell
$ sudo mkdir -p /opt/td-agent /var/cache/omnibus
$ sudo chown [USER] /opt/td-agent
$ sudo chown [USER] /var/cache/omnibus
```

After that, you create a platform-specific package using the `build project` command:

```shell
$ bin/omnibus build project td-agent2
```

The platform/architecture type of the package created will match the platform
where the `build project` command is invoked. So running this command on say a
MacBook Pro will generate a Mac OS X specific package. After the build
completes packages will be available in `pkg/`.

### Clean

You can clean up all temporary files generated during the build process with
the `clean` command:

```shell
$ bin/omnibus clean
```

Adding the `--purge` purge option removes __ALL__ files generated during the
build including the project install directory (`/opt/td-agent`) and
the package cache directory (`/var/cache/omnibus/pkg`):

```shell
$ bin/omnibus clean --purge
```

### Help

Full help for the Omnibus command line interface can be accessed with the
`help` command:

```shell
$ bin/omnibus help
```

## Vagrant-based Virtualized Build Lab

td-agent omnibus ships will a project-specific [Berksfile](http://berkshelf.com/) and [Vagrantfile](http://www.vagrantup.com/)
that will allow you to build your projects on the following platforms:

* CentOS 5 64-bit
* CentOS 5 32-bit
* CentOS 6 64-bit
* CentOS 6 32-bit
* Ubuntu 10.04 64-bit
* Ubuntu 10.04 32-bit
* Ubuntu 12.04 64-bit
* Ubuntu 12.04 32-bit

Please note this build-lab is only meant to get you up and running quickly;
there's nothing inherent in Omnibus that restricts you to just building CentOS
or Ubuntu packages. See the Vagrantfile to add new platforms to your build lab.

The only requirements for standing up this virtualized build lab are:

* VirtualBox - native packages exist for most platforms and can be downloaded
from the [VirtualBox downloads page](https://www.virtualbox.org/wiki/Downloads).
* Vagrant 1.2.1+ - native packages exist for most platforms and can be downloaded
from the [Vagrant downloads page](http://downloads.vagrantup.com/).

The [vagrant-berkshelf](https://github.com/RiotGames/vagrant-berkshelf) and
[vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus) Vagrant plugins
are also required and can be installed easily with the following commands:

```shell
# $ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-berkshelf --plugin-version = 2.0.1
$ vagrant plugin install vagrant-omnibus
```

Once the pre-requisites are installed you can build your package across all
platforms with the following command:

```shell
$ vagrant up
```

If you would like to build a package for a single platform the command looks like this:

```shell
$ vagrant up PLATFORM
```

The complete list of valid platform names can be viewed with the `vagrant status` command.

### pkg_build command

You can build all environments via `bin/pkg_build` command.

```sh
./bin/pkg_build
```

After that, each package is stored in `built_pkg` directory.

```sh
% ls built_pkg/
centos-5.10/  centos-6.5/   ubuntu-10.04/ ubuntu-12.04/
```

### Tested environment

```sh
% vagrant --version
Vagrant 1.6.1

% VBoxHeadless --version
Oracle VM VirtualBox Headless Interface 4.3.10
(C) 2008-2014 Oracle Corporation
All rights reserved.

4.3.10r93012

% ruby --version
ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-darwin13.0]
```

### NOTE

Vagrant syncs current directory in each platform. Downloaded gems are also installed automatically.

And you should not use `rbenv local` in project root because Ruby environment is built on top of rbenv in Vagrant.
So if you set different Ruby verion in `.ruby-version`, running ruby code will fail during pacakging process. 

## Kitchen-based Build Environment

Every Omnibus project ships will a project-specific
[Berksfile](http://berkshelf.com/) and [Vagrantfile](http://www.vagrantup.com/)
that will allow you to build your omnibus projects on all of the projects listed
in the `.kitchen.yml`. You can add/remove additional platforms as needed by
changing the list found in the `.kitchen.yml` `platforms` YAML stanza.

This build environment is designed to get you up-and-running quickly. However,
there is nothing that restricts you to building on other platforms. Simply use
the [omnibus cookbook](https://github.com/opscode-cookbooks/omnibus) to setup
your desired platform and execute the build steps listed above.

The default build environment requires Test Kitchen and VirtualBox for local
development. Test Kitchen also exposes the ability to provision instances using
various cloud providers like AWS, DigitalOcean, or OpenStack. For more
information, please see the [Test Kitchen documentation](http://kitchen.ci).

Once you have tweaked your `.kitchen.yml` (or `.kitchen.local.yml`) to your
liking, you can bring up an individual build environment using the `kitchen`
command.

```shell
$ bundle exec kitchen converge ubuntu-12.04
```

Then login to the instance and build the project as described in the Usage
section:

```shell
$ bundle exec kitchen login ubuntu-12.04
[vagrant@ubuntu...] $ cd test-om
[vagrant@ubuntu...] $ bundle install
[vagrant@ubuntu...] $ ...
[vagrant@ubuntu...] $ ./bin/omnibus build project test-om
```

For a complete list of all commands and platforms, run `kitchen list` or
`kitchen help`.
