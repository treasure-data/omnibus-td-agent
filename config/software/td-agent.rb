name "td-agent"
#version '' # git ref

dependency "jemalloc"
dependency "ruby"
dependency "nokogiri"
dependency "postgresql"
dependency "fluentd"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  Dir.glob(File.expand_path(File.join(Omnibus::Config.project_root, 'plugin_gems', '*.gem'))).sort.each { |gem_path|
    args = ''
    if project.ohai['platform_family'] == 'mac_os_x' && gem_path.include?('-thrift-')
      # See: https://issues.apache.org/jira/browse/THRIFT-2219
      args << " -- --with-cppflags='-D_FORTIFY_SOURCE=0'"
    end
    gem "install --no-ri --no-rdoc #{gem_path} #{args}", :env => env
  }
end
