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

@test "show td-agent usage on unknown action (redhat)" {
  run_service unknown
  assert_output <<EOS
Usage: ${TMP}/etc/init.d/td-agent {start|stop|reload|restart|condrestart|status|configtest}
EOS
  assert_failure
}

@test "show td-agent usage on missing action (redhat)" {
  run_service
  assert_output <<EOS
Usage: ${TMP}/etc/init.d/td-agent {start|stop|reload|restart|condrestart|status|configtest}
EOS
  assert_failure
}
