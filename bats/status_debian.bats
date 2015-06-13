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
  stub status_of_proc "for arg; do echo \$arg; done"

  run_service status
  assert_output <<EOS
${TMP}/opt/td-agent/embedded/bin/ruby
td-agent
EOS
  assert_success

  unstub status_of_proc
}

@test "failed to show td-agent status (debian)" {
  stub status_of_proc "false"

  run_service status
  assert_failure

  unstub status_of_proc
}
