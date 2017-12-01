# For systems without journald.
mkdir -p /var/log/journal

# Copy host libsystemd into image to avoid compatibility issues. This operation
# is only performed if the host's lib is mounted into the container through a 
# volume such as -v /usr/lib64/:/host/lib/.
if [ -n "$(ls /host/lib/libsystemd* 2>/dev/null)" ]; then
  rm /lib/x86_64-linux-gnu/libsystemd*
  ln -s /host/lib/libsystemd* /lib/x86_64-linux-gnu/
fi

if [ -z "${METADATA_AGENT_URL:-}" -a -n "${METADATA_AGENT_HOSTNAME:-}" ]; then
  METADATA_AGENT_URL="http://${METADATA_AGENT_HOSTNAME}:8000"
fi
if [ -n "$METADATA_AGENT_URL" ]; then
  sed -i "s,http://local-metadata-agent.stackdriver.com:8000,$METADATA_AGENT_URL," \
    /etc/google-fluentd/google-fluentd.conf
fi

/usr/sbin/google-fluentd "$@"
