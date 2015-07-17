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

@test "show td-agent status successfully (redhat)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  stub kill "-0 1234 : true"

  run_service status
  assert_output <<EOS
td-agent is running
EOS
  assert_success

  unstub kill
}

@test "failed to show td-agent status (redhat)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  stub kill "-0 1234 : false"

  run_service status
  assert_output <<EOS
td-agent is not running
EOS
  assert_failure

  unstub kill
}
