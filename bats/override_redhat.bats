#!/usr/bin/env bats

load test_helper

setup() {
  init_redhat
}

teardown() {
  rm -fr "${TMP}"/*
}

custom_run() {
  cat > "${TMP}/etc/sysconfig/td-agent"
  run_service "${1:-start}"
  assert_success
}

@test "start td-agent with custom arguments successfully (redhat)" {
  stub getent "passwd : echo nobody:x:100:100:,,,:/:/sbin/nologin"
  stub chown "true" \
             "true"
  stub getent "group : echo nogroup:x:100:"
  rm -f "${TMP}/path/to/td-agent.pid"
  stub daemon "echo; for arg; do echo \"  \$arg\"; done"
  stub log_success_msg "td-agent : true"
  custom_run <<EOS
DAEMON_ARGS="--user nobody -10"
PIDFILE="${TMP}/path/to/td-agent.pid"
TD_AGENT_ARGS="/path/to/td-agent --verbose --verbose --group nogroup --log /path/to/td-agent.log"
EOS
  assert_output <<EOS
Warning: Declaring \$PIDFILE in ${TMP}/etc/sysconfig/td-agent has been deprecated. Use \$TD_AGENT_PIDFILE instead.
Warning: Declaring --user in \$DAEMON_ARGS has been deprecated. Use \$TD_AGENT_USER instead.
Warning: Declaring --group in \$TD_AGENT_ARGS has been deprecated. Use \$TD_AGENT_GROUP instead.
Starting td-agent: 
  --pidfile=${TMP}/path/to/td-agent.pid
  -10
  --user
  nobody
  ${TMP}/opt/td-agent/embedded/bin/ruby
  /path/to/td-agent
  --verbose
  --verbose
  --log
  /path/to/td-agent.log
  --group
  nogroup
  --daemon
  ${TMP}/path/to/td-agent.pid
EOS
  [ -f "${TMP}/var/lock/subsys/td-agent" ]
  unstub getent
  unstub chown
  unstub log_success_msg
}

@test "start td-agent with --user=... and --group=... in configuration variables successfully (redhat)" {
  stub getent "passwd : echo nobody:x:100:100:,,,:/:/sbin/nologin"
  stub chown "true" \
             "true"
  stub getent "group : echo nogroup:x:100:"
  rm -f "${TMP}/path/to/td-agent.pid"
  stub daemon "echo; for arg; do echo \"  \$arg\"; done"
  stub log_success_msg "td-agent : true"
  custom_run <<EOS
DAEMON_ARGS="--user=nobody"
PIDFILE="${TMP}/path/to/td-agent.pid"
TD_AGENT_ARGS="/path/to/td-agent --verbose --verbose --group=nogroup --log /path/to/td-agent.log"
EOS
  assert_output <<EOS
Warning: Declaring \$PIDFILE in ${TMP}/etc/sysconfig/td-agent has been deprecated. Use \$TD_AGENT_PIDFILE instead.
Warning: Declaring --user in \$DAEMON_ARGS has been deprecated. Use \$TD_AGENT_USER instead.
Warning: Declaring --group in \$TD_AGENT_ARGS has been deprecated. Use \$TD_AGENT_GROUP instead.
Starting td-agent: 
  --pidfile=${TMP}/path/to/td-agent.pid
  --user
  nobody
  ${TMP}/opt/td-agent/embedded/bin/ruby
  /path/to/td-agent
  --verbose
  --verbose
  --log
  /path/to/td-agent.log
  --group
  nogroup
  --daemon
  ${TMP}/path/to/td-agent.pid
EOS
  [ -f "${TMP}/var/lock/subsys/td-agent" ]
  unstub getent
  unstub chown
  unstub log_success_msg
}

@test "start td-agent with custom configurations successfully (redhat)" {
  stub getent "passwd : echo custom_td_agent_user:x:501:501:,,,:/var/lib/custom_td_agent_user:/sbin/nologin"
  stub chown "true" \
             "true"
  stub getent "group : echo custom_td_agent_group:x:501:"
  mkdir -p "${TMP}/path/to"
  touch "${TMP}/path/to/custom_td_agent_ruby"
  chmod +x "${TMP}/path/to/custom_td_agent_ruby"
  rm -f "${TMP}/path/to/td-agent.pid"
  stub daemon "echo; for arg; do echo \"  \$arg\"; done"
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
TD_AGENT_LOCK_FILE="${TMP}/path/to/custom_td_agent_lock_file"
TD_AGENT_OPTIONS="--use-v0-config --no-supervisor"
EOS
  assert_output <<EOS
Starting custom_td_agent_name: 
  --pidfile=${TMP}/path/to/custom_td_agent_pid_file
  --user
  custom_td_agent_user
  ${TMP}/path/to/custom_td_agent_ruby
  ${TMP}/path/to/custom_td_agent_bin_file
  --log
  ${TMP}/path/to/custom_td_agent_log_file
  --use-v0-config
  --no-supervisor
  --group
  custom_td_agent_group
  --daemon
  ${TMP}/path/to/custom_td_agent_pid_file
EOS
  [ -f "${TMP}/path/to/custom_td_agent_lock_file" ]
  unstub getent
  unstub chown
  unstub log_success_msg
}
