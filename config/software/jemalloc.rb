name "jemalloc"
default_version "4.2.1"

# for td-agent
version("2.2.5") { source :md5 => 'a5c4332705ed0e3fff1ac73cfe975640' }
version("3.6.0") { source :md5 => 'e76665b63a8fddf4c9f26d2fa67afdf2' }
version("4.2.1") { source :md5 => '094b0a7b8c77c464d0dc8f0643fd3901' }
version("4.5.0") { source :sha256 => '9409d85664b4f135b77518b0b118c549009dc10f6cba14557d170476611f6780' }
version('5.0.1') { source :sha256 => '4814781d395b0ef093b21a08e8e6e0bd3dab8762f9935bbfb71679b0dea7c3e9' }

# On Mac, this file blocks package building at health check so add to whitelist
whitelist_file "libjemalloc\.1\.dylib"

source :url => "https://github.com/jemalloc/jemalloc/releases/download/#{version}/jemalloc-#{version}.tar.bz2"
relative_path "jemalloc-#{version}"

env = with_standard_compiler_flags(with_embedded_path)

build do
  command ["./configure", '--disable-debug',
           "--prefix=#{install_dir}/embedded"].join(" "), :env => env
  make "-j #{workers}", :env => env
  make "install", :env => env
end
