#!/usr/bin/env bats

load test_helper

setup() {
  init_debian
  stub_debian
}

teardown() {
  unstub_debian
  rm -fr "${TMP}"/*
}

@test "start td-agent with backward-compatibile configuration (debian)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  cat <<EOS > "${TMP}/etc/default/td-agent"
NAME="custom_name"
EOS

  stub_path /sbin/start-stop-daemon "echo; echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  stub log_success_msg "td-agent : true"

  run_service start
  assert_output <<EOS
Warning: Declaring \$NAME in ${TMP}/etc/default/td-agent for customizing \$PIDFILE has been deprecated. Use \$TD_AGENT_PID_FILE instead.
Starting td-agent: 
start-stop-daemon
  --start
  --quiet
  --pidfile
  ${TMP}/var/run/custom_name/custom_name.pid
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
  --use-v1-config
  --daemon
  ${TMP}/var/run/custom_name/custom_name.pid
EOS
  assert_success

  unstub_path /sbin/start-stop-daemon
  unstub log_success_msg
}
