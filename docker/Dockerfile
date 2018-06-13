FROM debian:stretch-20180426

# TODO: This may be a moving target, figure out how to pin.
RUN apt-get update \
    && apt-get install -y \
        curl \
        gnupg2 \
        lsb-release \
        procps \
        systemd \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    && apt-get autoremove

RUN curl -sS https://dl.google.com/cloudagents/install-logging-agent.sh | REPO_SUFFIX=20180511-1 DO_NOT_INSTALL_CATCH_ALL_CONFIG=true bash \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    && apt-get autoremove \
    && find /var/log -name "*.log" -type f -delete \
    && sed -i "s/num_threads 8/num_threads 8\n  detect_json true\n  # Enable metadata agent lookups.\n  enable_metadata_agent true\n  metadata_agent_url \"http:\/\/local-metadata-agent.stackdriver.com:8000\"/" "/etc/google-fluentd/google-fluentd.conf"

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/google-fluentd"]
