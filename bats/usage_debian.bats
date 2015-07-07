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

@test "show td-agent usage on unknown action (debian)" {
  run_service unknown
  assert_output <<EOS
Usage: ${TMP}/etc/init.d/td-agent {start|stop|reload|restart|force-reload|status|configtest}
EOS
  assert_failure
}

@test "show td-agent usage on missing action (debian)" {
  run_service
  assert_output <<EOS
Usage: ${TMP}/etc/init.d/td-agent {start|stop|reload|restart|force-reload|status|configtest}
EOS
  assert_failure
}
