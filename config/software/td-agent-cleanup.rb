name "td-agent-cleanup"
#version '' # git ref

dependency "td-agent"

build do
  block do
    project_name = project.name
    rb_major, rb_minor, rb_teeny = project.overrides[:ruby][:version].split("-", 2).first.split(".", 3)
    gem_dir_version = "#{rb_major}.#{rb_minor}.0" # gem path's teeny version is always 0

    # remove unnecessary files
    FileUtils.rm_f(Dir.glob("/opt/#{project_name}/embedded/lib/ruby/gems/#{gem_dir_version}/cache/*.gem"))
  end
end
