name "fluentd-ui"
default_version '8a322e7716370a1e2fdf69fda3266a1be477f221'

dependency "ruby"

source :git => 'https://github.com/fluent/fluentd-ui.git'
relative_path "fluentd-ui"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['BUNDLE_GEMFILE'] = 'Gemfile.production'
  ui_gems_path = File.expand_path(File.join(Omnibus::Config.project_root, 'ui_gems'))
  if File.exist?(ui_gems_path)
    Dir.glob(File.join(ui_gems_path, '*.gem')).sort.each { |gem_path|
      gem "install --no-ri --no-rdoc #{gem_path}"
    }
    rake "build", :env => env
    gem "install --no-ri --no-rdoc pkg/fluentd-ui-*.gem"
    td_agent_bin_dir = File.join(project.install_dir, 'embedded', 'bin')
    # Avoid deb's start-stop-daemon issue by providing another ruby binary. Will remove this ad-hoc code
    project_name_snake = project.name.gsub('-', '_')
    copy(File.join(td_agent_bin_dir, "ruby"), File.join(td_agent_bin_dir, "#{project_name_snake}_ui_ruby"))
  end
end
