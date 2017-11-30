dir 'plugin_gems'
download "httpclient", "2.8.2.4"
if td_agent_2?
  download "td-client", "0.8.85"
  download "td", "0.15.2"
  download "fluent-plugin-td", "0.10.29"
else
  download "td-client", "1.0.4"
  download "td", "0.15.7"
  download "fluent-plugin-td", "1.0.0"
end
if td_agent_2?
  download "aws-sdk", "2.10.91"
  download "fluent-plugin-s3", "0.8.5"
else
  download "jmespath", "1.3.1"
  download "aws-partitions", "1.42.0"
  download "aws-sigv4", "1.0.2"
  download "aws-sdk-core", "3.11.0"
  download "aws-sdk-kms", "1.3.0"
  download "aws-sdk-sqs", "1.3.0"
  download "aws-sdk-s3", "1.8.0"
  download "fluent-plugin-s3", "1.1.0"
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
  download "fluent-plugin-webhdfs", "1.2.2"
end
download "fluent-plugin-rewrite-tag-filter", "2.0.0"
download "ruby-kafka", "0.5.1"
download "fluent-plugin-kafka", "0.6.4"
unless td_agent_2?
  download "elasticsearch", "5.0.4"
  download "fluent-plugin-elasticsearch", "2.3.0"
end
download "fluent-plugin-td-monitoring", "0.2.3"
if windows?
  download 'win32-eventlog', '0.6.7'
  download 'fluent-plugin-windows-eventlog', '0.2.2'
end
