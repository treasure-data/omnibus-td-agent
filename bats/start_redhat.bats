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

@test "start td-agent successfully (redhat)" {
  rm -f "${TMP}/etc/sysconfig/td-agent"

  stub daemon "echo; for arg; do echo \"  \$arg\"; done"
  stub log_success_msg "td-agent : true"

  run_service start
  assert_output <<EOS
Starting td-agent: 
  --pidfile=${TMP}/var/run/td-agent/td-agent.pid
  --user
  td-agent
  ${TMP}/opt/td-agent/embedded/bin/ruby
  ${TMP}/usr/sbin/td-agent
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
  --group
  td-agent
  --daemon
  ${TMP}/var/run/td-agent/td-agent.pid
EOS
  assert_success
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub daemon
  unstub log_success_msg
}

@test "failed to start td-agent (redhat)" {
  stub daemon "false"
  stub log_failure_msg "td-agent : true"

  run_service start
  assert_output <<EOS
Starting td-agent: 
EOS
  assert_failure
  [ ! -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub daemon
  unstub log_failure_msg
}
