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
  stub status "-p ${TMP}/var/run/td-agent/td-agent.pid td-agent : true"

  run_service status
  assert_success

  unstub status
}

@test "failed to show td-agent status (redhat)" {
  stub status "-p ${TMP}/var/run/td-agent/td-agent.pid td-agent : false"

  run_service status
  assert_failure

  unstub status
}
