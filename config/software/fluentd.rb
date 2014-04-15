name "fluentd"
default_version '9fea4bd69420daf86411937addc6000dfcc6043b'
#version '1229278fe48ddc449ad501aa9c114b4597a794da' # git ref

dependency "ruby"
#dependency "bundler"

source :git => 'https://github.com/fluent/fluentd.git'
relative_path "fluentd"

env = {
  #"GEM_PATH" => nil,
  #"GEM_HOME" => nil
  #"PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
}

build do
  Dir.glob(File.expand_path(File.join(project_root, 'core_gems', '*.gem'))).sort.each { |gem_path|
    #command "#{install_dir}/ruby/bin/gem install --no-ri --no-rdoc #{gem_path}", :env => env
    gem "install --no-ri --no-rdoc #{gem_path}"
  }
  #command "rake build"
  rake "build"
  #command "#{install_dir}/ruby/bin/gem install --no-ri --no-rdoc pkg/fluentd-*.gem", :env => env
  gem "install --no-ri --no-rdoc pkg/fluentd-*.gem"
  #command "sudo ln -fs #{install_dir}/ruby/bin/fluentd #{install_dir}/bin/fluentd", :env => env
end
