#!/usr/bin/env bats

load test_helper

setup() {
  init_debian
}

teardown() {
  rm -fr "${TMP}"/*
}

custom_run() {
  cat > "${TMP}/etc/default/td-agent"
  run_service "${1:-start}"
  assert_success
}

@test "start td-agent with additional arguments successfully (debian)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  stub_debian
  stub_path /sbin/start-stop-daemon "echo; echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  stub log_success_msg "td-agent : true"
  custom_run <<EOS
DAEMON_ARGS="--verbose --verbose"
EOS
  assert_output <<EOS
Starting td-agent: 
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
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --verbose
  --verbose
  --use-v1-config
  --daemon
  ${TMP}/var/run/td-agent/td-agent.pid
EOS
  unstub_path /sbin/start-stop-daemon
  unstub log_success_msg
  unstub_debian
}

@test "start td-agent with custom configurations successfully (debian)" {
  stub getent "passwd : echo custom_td_agent_user:x:501:501:,,,:/var/lib/custom_td_agent_user:/sbin/nologin"
  stub chown "true" \
             "true"
  stub getent "group : echo custom_td_agent_group:x:501:"
  mkdir -p "${TMP}/path/to"
  rm -f "${TMP}/path/to/custom_td_agent_pid_file"
  stub_path /sbin/start-stop-daemon "echo; echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  touch "${TMP}/path/to/custom_td_agent_ruby"
  chmod +x "${TMP}/path/to/custom_td_agent_ruby"
  stub log_success_msg "custom_td_agent_name : true"
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
TD_AGENT_OPTIONS="--use-v0-config --no-supervisor"
EOS
  assert_output <<EOS
Starting custom_td_agent_name: 
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
  --log
  ${TMP}/path/to/custom_td_agent_log_file
  --use-v0-config
  --no-supervisor
  --daemon
  ${TMP}/path/to/custom_td_agent_pid_file
EOS
  unstub_path /sbin/start-stop-daemon
  unstub log_success_msg
  unstub getent
  unstub chown
}
