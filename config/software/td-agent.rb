name "td-agent"
#version '' # git ref

dependency "ruby"
dependency "bundler"
dependency "jemalloc"
dependency "fluentd"
dependency "nokogiri"

env = {}

build do
  Dir.glob(File.expand_path(File.join(project_root, 'plugin_gems', '*.gem'))).sort.each { |gem_path|
    command "sudo #{install_dir}/ruby/bin/gem install --no-ri --no-rdoc #{gem_path}", :env => env
  }

  command "rsync -a #{Omnibus.project_root}/files/ #{install_dir}/"
end
