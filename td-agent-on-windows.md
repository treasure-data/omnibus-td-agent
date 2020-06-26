How to build td-agent package on Windows
========================================

Prerequisite
------------

### Ruby MinGW

Download [RubyInstaller](http://rubyinstaller.org/downloads/) and install it.
You have to choice the x64 package.
I strongly recommend you to choice Ruby 2.5.7 or 2.6.6 with devkit installer.

You have to run this command (e.g. Ruby 2.6.6 case):
    C:\> ruby -e "puts RubyInstaller::Runtime.msys2_installation.msys_path + '\usr\bin'"
    C:\Ruby26-x64\msys64\usr\bin
    C:\> cd C:\Ruby26-x64\msys64\usr\bin
    C:\Ruby26-x64\msys64\usr\bin> copy bsdtar.exe tar.exe


### Git

Download [Git for Windows](https://git-for-windows.github.io/) and install it.

Set your email and name to git config.

    C:\> git config --global user.email "you@example.com"

    C:\> git config --global user.name "Your Name"


### MSYS2

Download [MSYS2](http://msys2.github.io/) and install it.
You hove to choice x86_64 package.
Set `PATH` to `C:\msys64\usr\bin`.

And, you also have to set `SSL_CERT_FILE` environment variable to the path of `cert.pem` included in MSYS2 package.

    C:\> set SSL_CERT_FILE=C:\msys64\usr\ssl\cert.pem


### patch

After installtion of MSYS2, do as below:

    C:\> pacman -S patch

And answer `Y` when you are asked to install.

### Bundler

If you use the latest bundler, use the following command to install bundler:

    gem install bundler

### WiX Toolset

There is no mention about this in the document of Omnibus, but WiX Toolset is required by Omnibus when creating MSI.

Download [WiX Toolset](http://wixtoolset.org/releases/) and install it.
If you use Windows Server 2012 R2, use version 3.10. 3.11 doesn't work on Window Server 2012 by .NET version mismatch.

It seems that the installer does not set `PATH` environment variable.
Therefore, you have to set `PATH` to `%WIX%\bin`.

### Windows SDK

There is no mention about this in the document of Omnibus, but SDK tools are required by Omnibus when creating MSI.

Download [Windows SDK](https://developer.microsoft.com/windows/downloads/windows-10-sdk) and install it.

The installer does not set `PATH` environment variable.
Therefore, you have to set `PATH` to `C:\Program Files (x86)\Windows Kits\10\bin\x64`

If you got the `makeappex.exe` is nout found error, you should also have to set `PATH` to `C:\Program Files (x86)\Windows Kits\10\bin\10.0.<BUILD NUMBER>.0\x64`.

Build td-agent-3
----------------

First, get [omnibus-td-agent](https://github.com/treasure-data/omnibus-td-agent) GitHub.

Then, do installation as written in `README.md` of omnibus-td-agent.

The build process is a little difference from `README.me`.

1. Download gems as below:

       C:\[your work dir]> bundle exec ruby bin\gem_downloader core_gems.rb

       C:\[your work dir]> bundle exec ruby bin\gem_downloader plugin_gems.rb


2. You don't have to create cache directory of omnibus on Windows.
   It'll be automatically made by Omnibus at `C:\omnibus-ruby`.

   But you have to create install directory as a symbolic link as an administrator.

       C:\> mkdir C:\DevKit\opt

       C:\> mklink /D \opt C:\DevKit\opt


3. Build

   Do as below:

       C:\[your work dir]> ridk exec bundle exec ruby bin\omnibus build td-agent3 -o windows_arch:x64
