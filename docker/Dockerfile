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
    && apt-get purge -y \
        curl \
        lsb-release \
        build-essential \
        gtk2.0 \
        adduser \
        libkrb5-3 \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    && apt-get autoremove -y --purge \
    && find /var/log -name "*.log" -type f -delete \
    # Remove .a .c .cc .h files and include libraries
    && rm -rf /opt/google-fluentd/embedded/include /opt/google-fluentd/embedded/lib/*.a \
    && (find /opt/google-fluentd/embedded/ -name '*.c' -o -name '*.cc' -o -name '*.h'  | xargs rm) \
    # Remove docs.
    && rm -rf \
        /usr/share/doc \
        /usr/share/man \
        /opt/google-fluentd/embedded/lib/ruby/gems/*/doc \
        /opt/google-fluentd/embedded/share/doc \
        /opt/google-fluentd/embedded/share/gtk-doc \
        /opt/google-fluentd/embedded/share/man \
        /opt/google-fluentd/embedded/share/terminfo \
    # Remove unused gems.
    && /opt/google-fluentd/embedded/bin/gem uninstall -ax --force \
        # Gems for ingesting logs to Treasure Data Cloud.
        td \
        td-client \
        td-logger \
        fluent-plugin-td \
        fluent-plugin-td-monitoring \
        hirb \
        parallel \
        ohai \
        mixlib-cli \
        mixlib-config \
        mixlib-log \
        mixlib-shellout \
        systemu \
    # Remove unused api client libraries.
    && (find /opt/google-fluentd/embedded/lib/ruby/gems/*/gems/google-api-client-*/generated/google/apis -mindepth 1 -maxdepth 1 \! -name 'logging*' | xargs rm -rf) \
    && sed -i "s/num_threads 8/num_threads 8\n  detect_json true\n  # Enable metadata agent lookups.\n  enable_metadata_agent true\n  metadata_agent_url \"http:\/\/local-metadata-agent.stackdriver.com:8000\"/" "/etc/google-fluentd/google-fluentd.conf"

ENV LD_PRELOAD=/opt/google-fluentd/embedded/lib/libjemalloc.so

COPY entrypoint.sh Dockerfile VERSION /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/google-fluentd"]
