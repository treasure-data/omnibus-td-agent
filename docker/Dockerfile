FROM debian:7.11-slim

# TODO: This may be a moving target, figure out how to pin.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        gnupg2 \
        lsb-release \
        build-essential \
        procps \
        systemd \
        ca-certificates \
        adduser \
    # Install google-fluentd at version 1.5.35-1.
    && curl -sS https://dl.google.com/cloudagents/install-logging-agent.sh | REPO_SUFFIX=20180810-1 DO_NOT_INSTALL_CATCH_ALL_CONFIG=true bash \
    # Clean up to reduce image size.
    && apt-get remove -y \
        curl \
        lsb-release \
        build-essential \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    && apt-get autoremove -y \
    && find /var/log -name "*.log" -type f -delete \
    # Remove docs.
    && rm -rf /usr/share/doc /usr/share/man /opt/google-fluentd/embedded/share/doc /opt/google-fluentd/embedded/lib/ruby/gems/*/doc ./opt/google-fluentd/embedded/lib/ruby/*/rdoc /opt/google-fluentd/embedded/share/gtk-doc /opt/google-fluentd/embedded/share/man /opt/google-fluentd/embedded/share/terminfo \
    # Remove gems that are only needed when ingesting logs to Treasure Data Cloud.
    && /opt/google-fluentd/embedded/bin/gem uninstall td td-client td-logger fluent-plugin-td fluent-plugin-td-monitoring hirb parallel ohai mixlib-cli mixlib-config mixlib-log mixlib-shellout systemu -ax --force \
    # Remove unused api client libraries.
    && cd /opt/google-fluentd/embedded/lib/ruby/gems/2.4.0/gems/google-api-client-0.23.4/generated/google/apis && ls -1 /opt/google-fluentd/embedded/lib/ruby/gems/2.4.0/gems/google-api-client-0.23.4/generated/google/apis | grep -v 'logging' | xargs rm -rf \
    && sed -i "s/num_threads 8/num_threads 8\n  detect_json true\n  # Enable metadata agent lookups.\n  enable_metadata_agent true\n  metadata_agent_url \"http:\/\/local-metadata-agent.stackdriver.com:8000\"/" "/etc/google-fluentd/google-fluentd.conf"

ENV LD_PRELOAD=/opt/google-fluentd/embedded/lib/libjemalloc.so

COPY entrypoint.sh Dockerfile VERSION /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/google-fluentd"]
