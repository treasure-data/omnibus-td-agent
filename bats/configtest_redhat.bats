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

  run_service configtest
  assert_output <<EOS
td-agent
  --group
  td-agent
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
  --daemon
  ${TMP}/var/run/td-agent/td-agent.pid
  --user
  td-agent
  --dry-run
  -q
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
}

@test "configuration test failure (redhat)" {
  stub_path /usr/sbin/td-agent "false"

  run_service configtest
  assert_failure

  unstub_path /usr/sbin/td-agent
}
