name "td-agent"
#version '' # git ref

dependency "jemalloc" unless windows?
dependency "ruby"
dependency "nokogiri"
dependency "postgresql" unless windows?
dependency "fluentd"

# rdkafka with SASL, healthcheck blocks this file so add it to whitelist.
whitelist_file "/opt/td-agent[/]+embedded/lib/ruby/gems/2\.4\.0/gems/rdkafka-0\.8\.0/ext/librdkafka\.(dylib|so)"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  Dir.glob(File.expand_path(File.join(Omnibus::Config.project_root, 'plugin_gems', '*.gem'))).sort.each { |gem_path|
    args = ''
    if project.ohai['platform_family'] == 'mac_os_x' && gem_path.include?('-thrift-')
      # See: https://issues.apache.org/jira/browse/THRIFT-2219
      args << " -- --with-cppflags='-D_FORTIFY_SOURCE=0'"
    end
    gem "install --no-document #{gem_path} #{args}", :env => env
  }
end
