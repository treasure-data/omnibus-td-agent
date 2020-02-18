dir 'plugin_gems'
download "httpclient", "2.8.2.4"
if td_agent_2?
  download "td-client", "0.8.85"
  download "td", "0.15.2"
  download "fluent-plugin-td", "0.10.29"
else
  download "td-client", "1.0.7"
  download "td", "0.16.8"
  download "fluent-plugin-td", "1.1.0"
end
if td_agent_2?
  download "aws-sdk", "2.11.68"
  download "fluent-plugin-s3", "0.8.7"
else
  download "jmespath", "1.4.0"
  download "aws-partitions", "1.273.0"
  download "aws-sigv4", "1.1.0"
  download "aws-sdk-core", "3.90.0"
  download "aws-sdk-kms", "1.29.0"
  download "aws-sdk-sqs", "1.23.1"
  download "aws-sdk-s3", "1.60.2"
  download "fluent-plugin-s3", "1.3.0"
end
if td_agent_2?
  download "thrift", "0.8.0"
  download "fluent-plugin-scribe", "0.10.14"
  download "bson", "4.1.1"
  download "mongo", "2.2.7"
  download "fluent-plugin-mongo", "0.8.1"
end
download "webhdfs", "0.9.0"
if td_agent_2?
  download "fluent-plugin-webhdfs", "0.7.1"
else
  download "fluent-plugin-webhdfs", "1.2.4"
end
if td_agent_2?
  download "fluent-plugin-rewrite-tag-filter", "1.6.0"
else
  download "fluent-plugin-rewrite-tag-filter", "2.2.0"
end
download "ruby-kafka", "0.7.10"
unless windows?
  download "rdkafka", "0.7.0"
end
download "fluent-plugin-kafka", "0.12.3"
unless td_agent_2?
  download "elasticsearch", "6.8.1"
  download "fluent-plugin-elasticsearch", "4.0.3"
  download "prometheus-client", "0.9.0"
  download "fluent-plugin-prometheus", "1.7.3"
  download "fluent-plugin-prometheus_pushgateway", "0.0.1"
end
if td_agent_2?
  download "fluent-plugin-record-modifier", "0.6.2"
else
  download "fluent-plugin-record-modifier", "2.1.0"
  unless windows?
    download "systemd-journal", "1.3.3"
    download "fluent-plugin-systemd", "1.0.2"
  end
end
download "fluent-plugin-td-monitoring", "0.2.4"
if windows?
  download 'win32-eventlog', '0.6.7'
  download 'winevt_c', '0.7.0'
  download 'fluent-plugin-windows-eventlog', '0.5.0'
end
