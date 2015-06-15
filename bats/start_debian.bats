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

@test "start td-agent successfully (debian)" {
  rm -f "${TMP}/etc/default/td-agent"

  stub_path /sbin/start-stop-daemon "true" \
                                    "echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  stub log_end_msg "0 : true"

  run_service start
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
  --daemon
  ${TMP}/var/run/td-agent/td-agent.pid
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
EOS
  assert_success

  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}

@test "start td-agent with custom configuration successfully (debian)" {
  cat <<EOS > "${TMP}/etc/default/td-agent"
DAEMON_ARGS="-vv"
NAME="custom_name"
EOS

  stub_path /sbin/start-stop-daemon "true" \
                                    "echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  stub log_end_msg "0 : true"

  run_service start
  assert_output <<EOS
Warning: Declaring \$NAME in ${TMP}/etc/default/td-agent for customizing \$PIDFILE has been deprecated. Use \$TD_AGENT_PID_FILE instead.
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
  -vv
  --daemon
  ${TMP}/var/run/custom_name/custom_name.pid
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
EOS
  assert_success

  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}

@test "start td-agent but it has already been started (debian)" {
  stub_path /sbin/start-stop-daemon "false"
  stub log_end_msg "0 : true"

  run_service start
  assert_success

  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}

@test "failed to start td-agent (debian)" {
  stub_path /sbin/start-stop-daemon "true" \
                                    "false"
  stub log_end_msg "1 : false"

  run_service start
  assert_failure

  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}
