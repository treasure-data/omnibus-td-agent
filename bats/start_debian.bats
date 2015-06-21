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
                                    "echo; echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  stub log_end_msg "0 : true"

  run_service start
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
  --use-v1-config
  --daemon
  ${TMP}/var/run/td-agent/td-agent.pid
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
