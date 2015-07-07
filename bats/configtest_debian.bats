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

@test "configuration test success (debian)" {
  stub_path /usr/sbin/td-agent "echo td-agent; for arg; do echo \"  \$arg\"; done"
  stub log_success_msg "td-agent : true"

  run_service configtest
  assert_output <<EOS
td-agent
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
  --daemon
  ${TMP}/var/run/td-agent/td-agent.pid
  --user
  td-agent
  --group
  td-agent
  --dry-run
  -q
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub log_success_msg
}

@test "configuration test failure (debian)" {
  stub_path /usr/sbin/td-agent "false"
  stub log_failure_msg "td-agent : true"

  run_service configtest
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub log_failure_msg
}
