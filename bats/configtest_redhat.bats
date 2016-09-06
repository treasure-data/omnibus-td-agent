#!/usr/bin/env bats

load test_helper

setup() {
  init_redhat
  stub_redhat
}

teardown() {
  unstub_redhat
  rm -fr "${TMP}"/*
}

@test "configuration test success (redhat)" {
  stub_path /usr/sbin/td-agent "echo td-agent; for arg; do echo \"  \$arg\"; done"
  stub log_success_msg "td-agent : true"

  run_service configtest
  assert_output <<EOS
td-agent
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
  --group
  td-agent
  --daemon
  ${TMP}/var/run/td-agent/td-agent.pid
  --user
  td-agent
  --dry-run
  -q
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub log_success_msg
}

@test "configuration test failure (redhat)" {
  stub_path /usr/sbin/td-agent "false"
  stub log_failure_msg "td-agent : true"

  run_service configtest
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub log_failure_msg
}
