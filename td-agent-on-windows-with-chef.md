Build td-agent with Chef on Windows 2012 R2

# Install Chef DK

Install [Chef Development Kit](https://downloads.chef.io/chefdk). We use 3.3.23 version for building td-agent 3.2.1.

Set `C:\opscode\chefdk\embedded\bin` to `PATH` environment variable for using ruby in `cmd.exe`.

# Init chef-repo

Run Chef Powershell and type commands:

```
# At C:/Users/Administrator
$ gem install knife-solo --no-document --pre # 0.6.x doesn't work so need pre version for avoiding gem mismatch.
$ knife solo init chef-repo
$ cd chef-repo
$ git init . ; git add . ; git commit -m "first" # Need git repo for "knife cookbook site install"
```

# Install omnibus cookbook

omnibus-toolchain requires omnibus cookbook.

```
$ knife cookbook site install omnibus
```

# Install omnibus-toolchain

Building omnibus package on Windows requires omnibus-toolchain. omnibus-toolchain includes compilers and some tools for omnibus projet build.

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

Run `chef-solo` in chef-repo in Chef PowerShell. This will install omnibus-toolchain. 

```
$ chef-solo -c .\solo.rb -j .\chef.json
```

## Windows SDK

There is no mention about Windows SDK in the document of Omnibus, but SDK tools, `makeappx` command, are required by Omnibus when creating MSI.
omnibus-toolchain installs Windows SDK but not set bin directory to `PATH`.

Therefore, you have to set `C:\Program Files (x86)\Windows Kits\VERSION\bin\x64` or similar to `PATH`.
`VERSION` is actual path like `8.1` or `10`.

# Build td-agent 3

## Clone omnibus-td-agent

This is in cmd.exe, not chef PowerShell because `gem_downloader` uses `curl`.
If you don't have curl, [download binary](https://curl.haxx.se/download.html#Win64) and copy it to `C:\opscode\chefdk\embedded\bin`.

```
$ git clone https://github.com/treasure-data/omnibus-td-agent
# may need to execute: git checkout -b release-x.x.x remotes/origin/release-3.2.1
$ ruby -Ilib ./bin/gem_downloader core_gems.rb
$ ruby -Ilib ./bin/gem_downloader plugin_gems.rb
```

## Run omnibus build

After installed omnibus-toolchain, use `cmd.exe` to build td-agent3. Don't use PowerShell because omnibus-toolchain assumes `cmd.exe`.

```
# Load env settings
$ C:\omnibus\load-omnibus-toolchain.bat
$ bundle install
$ bundle exec omnibus build td-agent3 -o windows_arch:x64
```
