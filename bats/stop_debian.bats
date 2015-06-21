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

@test "stop td-agent successfully (debian)" {
  stub_path /sbin/start-stop-daemon "echo; echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  stub log_end_msg "0 : true"

  run_service stop
  assert_output <<EOS
Stopping td-agent: 
start-stop-daemon
  --stop
  --quiet
  --retry=TERM/120/KILL/5
  --pidfile
  ${TMP}/var/run/td-agent/td-agent.pid
  --name
  ruby
EOS
  assert_success

  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}

@test "stop td-agent but it has already been stopped (debian)" {
  stub_path /sbin/start-stop-daemon "true"
  stub log_end_msg "0 : true"

  run_service stop
  assert_success

  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}

@test "failed to stop td-agent (debian)" {
  stub_path /sbin/start-stop-daemon "exit 2"
  stub log_end_msg "1 : false"

  run_service stop
  assert_failure

  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}
