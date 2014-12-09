require 'spec_helper'

describe package('td-agent') do
  it { should be_installed }
end

describe file('/etc/init.d/td-agent') do
  it { should be_executable }
  it { should be_mode 755 }
end

describe file('/etc/td-agent') do
  it { should be_directory }
end

describe file('/etc/td-agent/td-agent.conf') do
  it { should be_file }
  it { should contain '</match>' }
  it { should contain '</source>' }
end

%w(td-agent td-agent-gem td-agent-ui).each do |command|
  describe file("/usr/sbin/#{command}") do
    it { should be_executable }
    it { should be_mode 755 }
  end
end

describe file('/opt/td-agent') do
  it { should be_directory }
end

describe group('td-agent') do 
  it { should exist }
end

describe user('td-agent') do 
  it { should exist }
end

describe user('td-agent') do 
  it { should belong_to_group 'td-agent' }
end

# Plugin tests.

describe command('/usr/sbin/td-agent-gem list') do
  %W(td td-monitoring mongo webhdfs rewrite-tag-filter s3 scribe).each { |plugin|
    its(:stdout) { should match Regexp.new("fluent-plugin-#{plugin}") }
  }
end
