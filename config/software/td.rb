name "td"
#version '' # git ref

dependency "td-agent-files"

build do
  block do
    # setup related files
    pkg_type = project.packagers_for_system.first.id.to_s
    install_path = project.install_dir # for ERB
    project_name = project.name # for ERB
    project_name_snake = project.name.gsub('-', '_') # for variable names in ERB
    project_name_snake_upcase = project_name_snake.upcase
    rb_major, rb_minor, rb_teeny = project.overrides[:ruby][:version].split("-", 2).first.split(".", 3)
    gem_dir_version = "#{rb_major}.#{rb_minor}.0" # gem path's teeny version is always 0

    template = ->(*parts) { File.join('templates', *parts) }
    generate_from_template = ->(dst, src, erb_binding, opts={}) {
      mode = opts.fetch(:mode, 0755)
      destination = dst.gsub('td-agent', project.name)
      FileUtils.mkdir_p File.dirname(destination)
      File.open(destination, 'w', mode) do |f|
        f.write ERB.new(File.read(src)).result(erb_binding)
      end
    }

    # setup td and td-agent scripts
    td_bin_path = File.join(install_path, 'usr', 'bin', 'td')
    # templates/usr/bin/td.erb -> INSTALL_PATH/usr/bin/td
    generate_from_template.call td_bin_path, template.call('usr', 'bin', 'td.erb'), binding, mode: 0755
  end
end
