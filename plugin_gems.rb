dir 'plugin_gems'
download "httpclient", "2.8.2.4"
if td_agent_2?
  download "td-client", "0.8.85"
  download "td", "0.15.2"
  download "fluent-plugin-td", "0.10.29"
else
  download "td-client", "1.0.6"
  download "td", "0.16.1"
  download "fluent-plugin-td", "1.0.0"
end
if td_agent_2?
  download "aws-sdk", "2.11.22"
  download "fluent-plugin-s3", "0.8.7"
else
  download "jmespath", "1.4.0"
  download "aws-partitions", "1.87.0"
  download "aws-sigv4", "1.0.2"
  download "aws-sdk-core", "3.21.2"
  download "aws-sdk-kms", "1.5.0"
  download "aws-sdk-sqs", "1.3.0"
  download "aws-sdk-s3", "1.13.0"
  download "fluent-plugin-s3", "1.1.3"
end
if td_agent_2?
  download "thrift", "0.8.0"
  download "fluent-plugin-scribe", "0.10.14"
  download "bson", "4.1.1"
  download "mongo", "2.2.7"
  download "fluent-plugin-mongo", "0.8.1"
end
download "webhdfs", "0.8.0"
if td_agent_2?
  download "fluent-plugin-webhdfs", "0.7.1"
else
  download "fluent-plugin-webhdfs", "1.2.3"
end
if td_agent_2?
  download "fluent-plugin-rewrite-tag-filter", "1.6.0"
else
  download "fluent-plugin-rewrite-tag-filter", "2.1.0"
end
download "ruby-kafka", "0.6.3"
download "fluent-plugin-kafka", "0.7.2"
unless td_agent_2?
  download "elasticsearch", "6.0.2"
  download "fluent-plugin-elasticsearch", "2.10.1"
end
download "fluent-plugin-td-monitoring", "0.2.4"
if windows?
  download 'win32-eventlog', '0.6.7'
  download 'fluent-plugin-windows-eventlog', '0.2.2'
end
