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

@test "show td-agent status successfully (debian)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  stub kill "-0 1234 : true"
  stub log_success_msg "true"

  run_service status
  assert_success

  unstub kill
  unstub log_success_msg
}

@test "failed to show td-agent status (debian)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  stub kill "-0 1234 : false"
  stub log_failure_msg "true"

  run_service status
  assert_failure

  unstub kill
  unstub log_failure_msg
}
