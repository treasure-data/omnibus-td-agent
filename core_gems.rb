dir 'core_gems'
download "bundler", "1.16.0"
download "msgpack", "1.2.0"
if td_agent_2?
  download "cool.io", "1.5.1"
else
  download "cool.io", "1.5.3"
end
download "http_parser.rb", "0.6.0"
download "yajl-ruby", "1.3.1"
download "sigdump", "0.2.4"
if td_agent_2?
  download "oj", "2.18.1"
else
  download "oj", "3.3.9"
end
download "tzinfo", "1.2.4"
download "tzinfo-data", "1.2017.3"
unless td_agent_2?
  download 'serverengine', '2.0.5'
end
if windows?
  download 'ffi', '1.9.18'
  download 'ffi-win32-extensions', '1.0.3'
  download 'win32-ipc', '0.7.0'
  download 'win32-event', '0.6.3'
  download 'win32-service', '0.8.10'
  download 'windows-pr', '1.2.6'
  download 'win32-api', '1.7.0-universal-mingw32'
  download 'windows-api', '0.4.4'
end
