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
  stub daemon "true"
  stub log_success_msg "td-agent : true"

  run_service restart
  assert_output <<EOS
Restarting td-agent: 
EOS
  assert_success
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub_path /usr/sbin/td-agent
  unstub killproc
  unstub daemon
  unstub log_success_msg
}

@test "failed to restart td-agent due to stop failure (redhat)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub killproc "false"
  stub log_failure_msg "td-agent : true"

  run_service restart
  assert_output <<EOS
Restarting td-agent: 
EOS
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub killproc
  unstub log_failure_msg
}

@test "failed to restart td-agent by configuration test failure (redhat)" {
  stub_path /usr/sbin/td-agent "false"
  stub log_failure_msg "td-agent : true"

  run_service restart
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub log_failure_msg
}

@test "failed to restart td-agent due to start failure (redhat)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub killproc "true"
  stub daemon "false"
  stub log_failure_msg "td-agent : true"

  run_service restart
  assert_output <<EOS
Restarting td-agent: 
EOS
  assert_failure
  [ ! -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub_path /usr/sbin/td-agent
  unstub killproc
  unstub daemon
  unstub log_failure_msg
}

@test "conditional restart of td-agent (redhat)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  stub_path /usr/sbin/td-agent "true"
  stub killproc "true"
  stub daemon "true"
  stub log_success_msg "td-agent : true"

  run_service condrestart
  assert_output <<EOS
Restarting td-agent: 
EOS
  assert_success
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub_path /usr/sbin/td-agent
  unstub killproc
  unstub daemon
  unstub log_success_msg
}

@test "conditional restart do nothing if lock file doesn't exist (redhat)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  rm -f "${TMP}/var/lock/subsys/td-agent"

  run_service condrestart
  assert_success
  [ ! -f "${TMP}/var/lock/subsys/td-agent" ]
}
