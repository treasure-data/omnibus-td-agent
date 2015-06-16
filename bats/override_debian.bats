#!/usr/bin/env bats

load test_helper

setup() {
  init_debian
}

teardown() {
  rm -fr "${TMP}"/*
}

custom_run() {
  stub log_end_msg "0 : true"
  cat > "${TMP}/etc/default/td-agent"
  run_service "${1:-start}"
  assert_success
  unstub log_end_msg
}

@test "start td-agent with additional arguments successfully (debian)" {
  stub_debian
  stub_path /sbin/start-stop-daemon "true" \
                                    "echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  custom_run <<EOS
DAEMON_ARGS="--verbose --verbose"
EOS
  assert_output <<EOS
start-stop-daemon
  --start
  --quiet
  --pidfile
  ${TMP}/var/run/td-agent/td-agent.pid
  --exec
  ${TMP}/opt/td-agent/embedded/bin/ruby
  -c
  td-agent
  --group
  td-agent
  --
  ${TMP}/usr/sbin/td-agent
  --verbose
  --verbose
  --daemon
  ${TMP}/var/run/td-agent/td-agent.pid
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
EOS
  unstub_path /sbin/start-stop-daemon
}

@test "start td-agent with custom configurations successfully (debian)" {
  stub getent "passwd : echo custom_td_agent_user:x:501:501:,,,:/var/lib/custom_td_agent_user:/sbin/nologin"
  stub chown true
  stub getent "group : echo custom_td_agent_group:x:501:"
  stub log_daemon_msg true
  stub_path /sbin/start-stop-daemon "true" \
                                    "echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  mkdir -p "${TMP}/path/to"
  touch "${TMP}/path/to/custom_td_agent_ruby"
  chmod +x "${TMP}/path/to/custom_td_agent_ruby"
  custom_run <<EOS
TD_AGENT_NAME="custom_td_agent_name"
TD_AGENT_HOME="${TMP}/path/to/custom_td_agent_home"
TD_AGENT_DEFAULT="${TMP}/path/to/custom_td_agent_default"
TD_AGENT_USER="custom_td_agent_user"
TD_AGENT_GROUP="custom_td_agent_group"
TD_AGENT_RUBY="${TMP}/path/to/custom_td_agent_ruby"
TD_AGENT_BIN_FILE="${TMP}/path/to/custom_td_agent_bin_file"
TD_AGENT_LOG_FILE="${TMP}/path/to/custom_td_agent_log_file"
TD_AGENT_PID_FILE="${TMP}/path/to/custom_td_agent_pid_file"
EOS
  assert_output <<EOS
start-stop-daemon
  --start
  --quiet
  --pidfile
  ${TMP}/path/to/custom_td_agent_pid_file
  --exec
  ${TMP}/path/to/custom_td_agent_ruby
  -c
  custom_td_agent_user
  --group
  custom_td_agent_group
  --
  ${TMP}/path/to/custom_td_agent_bin_file
  --daemon
  ${TMP}/path/to/custom_td_agent_pid_file
  --log
  ${TMP}/path/to/custom_td_agent_log_file
  --use-v1-config
EOS
  unstub_path /sbin/start-stop-daemon
  unstub getent
  unstub chown
  unstub log_daemon_msg
}
