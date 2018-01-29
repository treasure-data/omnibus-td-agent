td-agent-build with Chef on Windows 2012 R2

# Install Chef

Install `Chef Development Kit 2.2.1`. Latest versions have a problem with `bundle exec` so use 2.2.1 for now.

If you use latest version, e.g. 2.4.x, you hit `block in replace_bin_path': can't find executable omnibus for gem omnibus` error.

# Init chef-repo

Run Chef Powershell and type commands:

```
$ gem install knife-solo --no-document --pre # 0.6.x doesn't work so need pre version for avoiding gem mismatch.
$ knife solo init chef-repo
$ cd chef-repo
$ git init . ; git add . ; git commit -m "first" # Need git repo for "knife cookbook site install"
```

# Install omnibus cookbook

```
$ knife cookbook site install omnibus
# $ chef generate cookbook cookbooks/tdagent
```

# Clone omnibus-td-agent

This is in git shell, not chef PowerShell because `gem_downloader` uses `wget`.

```
$ git clone https://github.com/treasure-data/omnibus-td-agent
$ PATH=/c/optscode/chefdk/embedded/bin:$PATH
$ ruby -Ilib ./bin/gem_downloader core_gems.rb
$ ruby -Ilib ./bin/gem_downloader plugin_gems.rb
```

# Setup files

## chef-repo/solo.rb

```
cookbook_path ["C:/Users/Administrator/chef-repo/cookbooks"]
```

## chef-repo/chef.json

```
{
  "run_list":[
    "recipe[omnibus::default]"
  ]
}

```

Run `chef-solo` in chef-repo in Chef PowerShell. This will install omnibus-toolchain. omnibus-toolchain includes compilers and some tools for omnibus projet build.

```
$ chef-solo -c .\solo.rb -j .\chef.json
```

## Windows SDK

There is no mention about Windows SDK in the document of Omnibus, but SDK tools, `makeappx` command, are required by Omnibus when creating MSI.

Download [Windows SDK](https://developer.microsoft.com/windows/downloads/windows-10-sdk) and install it.

The installer does not set bin directory to `PATH` environment variable.
Therefore, you have to set `C:\Program Files (x86)\Windows Kits\10\bin\x64` or similar to `PATH`.

## Build td-agent3

After installed omnibus-toolchain and related tools, use `cmd.exe` to build td-agent3. Don't use PowerShell because omnibus-toolchain assumes `cmd.exe`.


```
# Load env settings
$ C:\omnibus\load-omnibus-toolchain.bat
$ bundle install
$ bundle exec omnibus build td-agent3
```
