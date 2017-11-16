FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install -y \
        curl \
        lsb-release \
    && curl -sS https://dl.google.com/cloudagents/install-logging-agent.sh | bash \
    && apt-get autoremove \
    && sed -i "s/num_threads 8/num_threads 8\n  detect_json true\n  # Enable metadata agent lookups.\n  enable_metadata_agent true\n  metadata_agent_url \"http:\/\/local-metadata-agent.stackdriver.com:8000\"/" "/etc/google-fluentd/google-fluentd.conf" \
    && rm -rf /var/lib/apt/lists/*

ADD run.sh /run.sh

CMD /run.sh
