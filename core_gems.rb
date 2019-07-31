dir 'core_gems'
download "bundler", "1.16.6"
download "msgpack", "1.2.9"
if td_agent_2?
  download "cool.io", "1.5.1"
else
  download "cool.io", "1.5.4"
end
download "http_parser.rb", "0.6.0"
download "yajl-ruby", "1.4.1"
download "sigdump", "0.2.4"
if td_agent_2?
  download "oj", "2.18.5"
else
  download "oj", "3.7.11"
end
download "tzinfo", "1.2.5"
download "tzinfo-data", "1.2019.2"
unless td_agent_2?
  download "dig_rb", "1.0.1"
  download 'serverengine', '2.1.1'
end
if windows?
  download 'ffi', '1.9.25'
  download 'ffi-win32-extensions', '1.0.3'
  download 'win32-ipc', '0.7.0'
  download 'win32-event', '0.6.3'
  download 'win32-service', '1.0.1'
  download 'win32-api', '1.7.1-universal-mingw32'
  download 'windows-pr', '1.2.6'
  download 'windows-api', '0.4.4'
end
