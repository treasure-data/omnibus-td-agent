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

@test "restart td-agent successfully (redhat)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  stub_path /usr/sbin/td-agent "true"
  stub killproc "true"
  stub success "true"
  stub daemon "true"

  run_service restart
  assert_output <<EOS
Shutting down td-agent: 
Starting td-agent: 
EOS
  assert_success
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub_path /usr/sbin/td-agent
  unstub killproc
  unstub success
  unstub daemon
}

@test "restart td-agent regardless of stop failure (redhat)" {
  stub_path /usr/sbin/td-agent "true"
  stub killproc "false"
  stub failure "false"
  stub daemon "true"

  run_service restart
  assert_output <<EOS
Shutting down td-agent: 
Starting td-agent: 
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub killproc
  unstub failure
  unstub daemon
}

@test "failed to restart td-agent by configuration test failure (redhat)" {
  stub_path /usr/sbin/td-agent "false"

  run_service restart
  assert_failure

  unstub_path /usr/sbin/td-agent
}

@test "failed to restart td-agent by start failure (redhat)" {
  stub_path /usr/sbin/td-agent "true"
  stub killproc "true"
  stub success "true"
  stub daemon "false"

  run_service restart
  assert_output <<EOS
Shutting down td-agent: 
Starting td-agent: 
EOS
  assert_failure
  [ ! -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub_path /usr/sbin/td-agent
  unstub killproc
  unstub success
  unstub daemon
}
