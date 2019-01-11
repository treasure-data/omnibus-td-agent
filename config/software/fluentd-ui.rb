name "fluentd-ui"
default_version '9357b3797df57b4944dd99051d9c3af65153703e'

dependency "ruby"

source :git => 'https://github.com/fluent/fluentd-ui.git'
relative_path "fluentd-ui"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['BUNDLE_GEMFILE'] = 'Gemfile.production'
  ui_gems_path = File.expand_path(File.join(Omnibus::Config.project_root, 'ui_gems'))
  if File.exist?(ui_gems_path)
    Dir.glob(File.join(ui_gems_path, '*.gem')).sort.each { |gem_path|
      gem "install --no-document #{gem_path}"
    }
    rake "build", :env => env
    gem "install --no-document pkg/fluentd-ui-*.gem"
    td_agent_bin_dir = File.join(project.install_dir, 'embedded', 'bin')
    # Avoid deb's start-stop-daemon issue by providing another ruby binary. Will remove this ad-hoc code
    project_name_snake = project.name.gsub('-', '_')
    copy(File.join(td_agent_bin_dir, "ruby"), File.join(td_agent_bin_dir, "#{project_name_snake}_ui_ruby"))
  end
end
