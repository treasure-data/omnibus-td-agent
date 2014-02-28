name "td-agent"
version '1229278fe48ddc449ad501aa9c114b4597a794da' # git ref
gem_version = '0.10.44'  # local_variable

dependency "ruby"
#dependency "rubygems"
dependency "bundler"

#source :git => "https://github.com/fluent/fluentd.git"
source :git => 'https://github.com/fluent/fluentd.git'
relative_path "fluentd"

env = {
  #"PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
}

build do
  #command "sudo #{install_dir}/embedded/bin/gem install json", :env => env
  command "rake build", :env => env
  #rake "gem", :env => env
  command "sudo #{install_dir}/embedded/bin/gem install --no-ri --no-rdoc pkg/fluentd-*.gem", :env => env
  command "sudo ln -fs #{install_dir}/embedded/bin/fluentd #{install_dir}/bin/fluentd", :env => env
end
