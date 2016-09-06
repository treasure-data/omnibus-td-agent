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

@test "stop td-agent successfully (redhat)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  stub kill "-TERM 1234 : true" \
             "-0 1234 : false" \
             "-0 1234 : false"
  stub log_success_msg "td-agent : true"

  run_service stop
  assert_output <<EOS
Stopping td-agent: 
EOS
  assert_success
  [ ! -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub kill
  unstub log_success_msg
}

@test "stop td-agent but it has already been stopped (redhat)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  stub kill "-TERM 1234 : false"
  stub log_failure_msg "td-agent : true"

  run_service stop
  assert_output <<EOS
Stopping td-agent: 
EOS
  assert_failure # TODO: change this to success for compatibility between debian
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub kill
  unstub log_failure_msg
}

@test "failed to stop td-agent (redhat)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  cat <<SH > "${TMP}/etc/sysconfig/td-agent"
STOPTIMEOUT=3
SH

  stub kill "-TERM 1234 : true" \
            "-0 1234 : true" \
            "-0 1234 : true" \
            "-0 1234 : true" \
            "-0 1234 : true"
  stub sleep "1 : true"
  stub log_failure_msg "td-agent : true"

  run_service stop
  assert_output <<EOS
Stopping td-agent: Timeout error occurred trying to stop td-agent...
EOS
  assert_failure
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub kill
  unstub log_failure_msg
}

@test "stop td-agent by name successfully (redhat)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  stub killproc "td-agent : true"
  stub log_success_msg "td-agent : true"

  run_service stop
  assert_output <<EOS
Stopping td-agent: 
EOS
  assert_success
  [ ! -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub killproc
  unstub log_success_msg
}

@test "failed to stop td-agent by name (redhat)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  stub killproc "td-agent : false"
  stub log_failure_msg "td-agent : true"

  run_service stop
  assert_output <<EOS
Stopping td-agent: 
EOS
  assert_failure
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub killproc
  unstub log_failure_msg
}
