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

@test "reload td-agent successfully (debian)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub kill "-HUP 1234 : true"
  stub log_end_msg "0 : true"

  run_service reload
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub kill
  unstub log_end_msg
}

@test "reload td-agent forcibly (debian)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub kill "-HUP 1234 : true"
  stub log_end_msg "0 : true"

  run_service force-reload
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub kill
  unstub log_end_msg
}

@test "failed to reload td-agent (debian)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub kill "-HUP 1234 : false"
  stub log_end_msg "1 : false"

  run_service reload
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub kill
  unstub log_end_msg
}

@test "failed to reload td-agent by missing pid file (debian)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub log_end_msg "1 : false"

  run_service reload
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub log_end_msg
}

@test "failed to reload td-agent by configuration test failure (debian)" {
  stub_path /usr/sbin/td-agent "false"
  stub log_end_msg "1 : false"

  run_service reload
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub log_end_msg
}
