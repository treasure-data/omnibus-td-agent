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

@test "reload td-agent successfully (debian)" {
  stub_path /usr/sbin/td-agent "true"
  stub_path /sbin/start-stop-daemon "echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  stub log_end_msg "0 : true"

  run_service reload
  assert_output <<EOS
start-stop-daemon
  --stop
  --signal
  1
  --quiet
  --pidfile
  ${TMP}/var/run/td-agent/td-agent.pid
  --name
  ruby
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}

@test "reload td-agent forcibly (debian)" {
  stub_path /usr/sbin/td-agent "true"
  stub_path /sbin/start-stop-daemon "echo start-stop-daemon; for arg; do echo \"  \$arg\"; done"
  stub log_end_msg "0 : true"

  run_service force-reload
  assert_output <<EOS
start-stop-daemon
  --stop
  --signal
  1
  --quiet
  --pidfile
  ${TMP}/var/run/td-agent/td-agent.pid
  --name
  ruby
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}

@test "failed to reload td-agent (debian)" {
  stub_path /usr/sbin/td-agent "true"
  stub_path /sbin/start-stop-daemon "false"
  stub log_end_msg "1 : false"

  run_service reload
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub_path /sbin/start-stop-daemon
  unstub log_end_msg
}

@test "failed to reload td-agent by configuration test failure (debian)" {
  stub_path /usr/sbin/td-agent "false"
  stub log_end_msg "1 : false"

  run_service reload
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub log_end_msg
}
