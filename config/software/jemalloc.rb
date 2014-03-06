name "jemalloc"
version "2.2.5"

source :url => "http://www.canonware.com/download/jemalloc/jemalloc-2.2.5.tar.bz2", :md5 => 'a5c4332705ed0e3fff1ac73cfe975640'

relative_path "jemalloc-2.2.5"

env = {
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
}

build do
  command ["./configure", '--disable-debug',
           "--prefix=#{install_dir}/embedded"].join(" "), :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env
end
