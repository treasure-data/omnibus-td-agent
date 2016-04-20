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

@test "stop td-agent successfully (debian)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"

  stub kill "-TERM 1234 : true" \
             "-0 1234 : false" \
             "-0 1234 : false"
  stub log_success_msg "td-agent : true"

  run_service stop
  assert_output <<EOS
Stopping td-agent: 
EOS
  assert_success

  unstub kill
  unstub log_success_msg
}

@test "stop td-agent but it has already been stopped (debian)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"

  stub kill "-TERM 1234 : false"
  stub log_failure_msg "td-agent : true"

  run_service stop
  assert_output <<EOS
Stopping td-agent: 
EOS
  assert_failure

  unstub kill
  unstub log_failure_msg
}

@test "failed to stop td-agent (debian)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"

  cat <<SH > "${TMP}/etc/default/td-agent"
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

  unstub kill
  unstub log_failure_msg
}
