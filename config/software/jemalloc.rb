name "jemalloc"
default_version "3.6.0"

# for google-fluentd
version("2.2.5") { source :md5 => 'a5c4332705ed0e3fff1ac73cfe975640' }
version("3.6.0") { source :md5 => 'e76665b63a8fddf4c9f26d2fa67afdf2' }

# On Mac, this file blocks package building at health check so add to whitelist
whitelist_file "libjemalloc\.1\.dylib"

source :url => "http://www.canonware.com/download/jemalloc/jemalloc-#{version}.tar.bz2"
relative_path "jemalloc-#{version}"

env = with_standard_compiler_flags(with_embedded_path)

build do
  command ["./configure", '--disable-debug',
           "--prefix=#{install_dir}/embedded"].join(" "), :env => env
  make "-j #{workers}", :env => env
  make "install", :env => env
end
