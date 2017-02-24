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
download "aws-sdk", "2.6.46"
if td_agent_2?
  download "fluent-plugin-s3", "0.8.1"
else
  download "fluent-plugin-s3", "1.0.0.rc2"
end
download "webhdfs", "0.8.0"
download "fluent-plugin-webhdfs", "0.4.2"
download "fluent-plugin-rewrite-tag-filter", "1.5.5"
download "ruby-kafka", "0.3.16"
download "fluent-plugin-kafka", "0.5.3"
unless td_agent_2?
  download "elasticsearch", "1.0.18"
  download "fluent-plugin-elasticsearch", "1.9.2"
end
download "fluent-plugin-td-monitoring", "0.2.2"
if windows?
  download 'win32-eventlog', '0.6.7'
  download 'fluent-plugin-windows-eventlog', '0.1.0'
end
