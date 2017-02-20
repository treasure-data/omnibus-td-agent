name "td-agent-cleanup"
#version '' # git ref

dependency "td-agent"
dependency "td-agent-files"

build do
  block do
    project_name = project.name
    rb_major, rb_minor, rb_teeny = project.overrides[:ruby][:version].split("-", 2).first.split(".", 3)
    gem_dir_version = "#{rb_major}.#{rb_minor}.0" # gem path's teeny version is always 0

    # remove unnecessary files
    FileUtils.rm_f(Dir.glob("/opt/#{project_name}/embedded/lib/ruby/gems/#{gem_dir_version}/cache/*.gem"))
    FileUtils.rm_rf(Dir.glob("/opt/#{project_name}/embedded/share/{doc,gtk-doc,terminfo}"))
    Dir.glob("/opt/#{project_name}/embedded/lib/ruby/gems/#{gem_dir_version}/gems/*").each { |gem_dir|
      if File.exist?("#{gem_dir}/ext")
        FileUtils.rm_f(Dir.glob("#{gem_dir}/ext/**/*.o"))
      end
      FileUtils.rm_rf(["#{gem_dir}/test", "{gem_dir}/spec"])
    }

    if windows?
      FileUtils.rm_rf("/opt/#{project_name}/etc/init.d")
    end
  end
end
