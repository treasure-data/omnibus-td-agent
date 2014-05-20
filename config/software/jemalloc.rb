name "jemalloc"
default_version "3.6.0"

# for td-agent
version "2.2.5" do
  source :md5 => 'a5c4332705ed0e3fff1ac73cfe975640'
end

version "3.6.0" do
  source :md5 => 'e76665b63a8fddf4c9f26d2fa67afdf2'
end

# On Mac, this file blocks package building at health check so add to whitelist
whitelist_file "libjemalloc\.1\.dylib"

source :url => "http://www.canonware.com/download/jemalloc/jemalloc-#{version}.tar.bz2"
relative_path "jemalloc-#{version}"

env = {
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
}

build do
  command ["./configure", '--disable-debug',
           "--prefix=#{install_dir}/embedded"].join(" "), :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env
end
