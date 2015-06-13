require 'rake'
require 'rspec/core/rake_task'
require 'shellwords'

task :spec    => ['spec:all', 'bats:all']
task :default => :spec

namespace :spec do
  targets = []
  Dir.glob('./spec/*').each do |dir|
    next unless File.directory?(dir)
    targets << File.basename(dir)
  end

  task :all     => targets
  task :default => :all

  targets.each do |target|
    desc "Run serverspec tests to #{target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['TARGET_HOST'] = target
      t.pattern = "spec/#{target}/*_spec.rb"
    end
  end
end

namespace :bats do
  bats_path = File.expand_path("../bats/bats", __FILE__)
  test_path = File.expand_path("../bats", __FILE__)

  desc "Run bats tests for init scripts"
  task :all => [:setup, :run]
  task :default => :all

  task :setup do
    unless File.exist?(bats_path)
      sh "git clone https://github.com/sstephenson/bats.git #{Shellwords.shellescape(bats_path)}"
    end
  end

  task :run do
    sh "#{Shellwords.shellescape(File.join(bats_path, "bin", "bats"))} --tap #{Shellwords.shellescape(test_path)}"
  end
end
