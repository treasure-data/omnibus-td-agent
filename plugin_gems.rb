dir 'plugin_gems'
download "httpclient", "2.8.2.4"
if td_agent_2?
  download "td-client", "0.8.85"
  download "td", "0.15.2"
  download "fluent-plugin-td", "0.10.29"
else
  download "td-client", "1.0.0"
  download "td", "0.15.2"
  download "fluent-plugin-td", "1.0.0.rc1"
end
download "uuidtools", "2.1.5"
download "aws-sdk", "2.9.19"
if td_agent_2?
  download "fluent-plugin-s3", "0.8.2"
else
  download "fluent-plugin-s3", "1.0.0.rc3"
end
if td_agent_2?
  download "thrift", "0.8.0"
  download "fluent-plugin-scribe", "0.10.14"
  download "bson", "4.1.1"
  download "mongo", "2.2.7"
  download "fluent-plugin-mongo", "0.8.0"
end
download "bzip2-ffi", "1.0.0" # This will be removed
download "webhdfs", "0.8.0"
download "fluent-plugin-webhdfs", "1.1.1"
download "fluent-plugin-rewrite-tag-filter", "1.5.5"
download "ruby-kafka", "0.3.17"
download "fluent-plugin-kafka", "0.5.5"
unless td_agent_2?
  download "elasticsearch", "5.0.4"
  download "fluent-plugin-elasticsearch", "1.9.5"
end
download "fluent-plugin-td-monitoring", "0.2.2"
if windows?
  download 'win32-eventlog', '0.6.7'
  download 'fluent-plugin-windows-eventlog', '0.2.0'
end
