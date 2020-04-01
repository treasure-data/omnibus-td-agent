dir 'core_gems'
download "bundler", "1.16.6"
download "msgpack", "1.3.3"
if td_agent_2?
  download "cool.io", "1.5.1"
  download "oj", "2.18.5"
else
  download "cool.io", "1.6.0"
  download 'serverengine', '2.2.1'
  download "oj", "3.8.1"
  download "async-http", "0.50.7"
end
download "http_parser.rb", "0.6.0"
download "yajl-ruby", "1.4.1"
download "sigdump", "0.2.4"
download "tzinfo", "2.0.1"
download "tzinfo-data", "1.2019.3"
if windows?
  download 'ffi', '1.12.2'
  download 'ffi-win32-extensions', '1.0.3'
  download 'win32-ipc', '0.7.0'
  download 'win32-event', '0.6.3'
  download 'win32-service', '2.1.5'
  download 'win32-api', '1.8.0-universal-mingw32'
  download 'windows-pr', '1.2.6'
  download 'windows-api', '0.4.4'
end
