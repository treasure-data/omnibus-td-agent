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

  stub kill "1234 : true" \
             "-0 1234 : false"
  stub success "true"

  run_service stop
  assert_output <<EOS
Shutting down td-agent: 
EOS
  assert_success
  [ ! -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub kill
  unstub success
}

@test "stop td-agent but it has already been stopped (redhat)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  stub kill "1234 : false"
  stub failure "false"

  run_service stop
  assert_output <<EOS
Shutting down td-agent: 
EOS
  assert_failure # TODO: change this to success for compatibility between debian
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub kill
  unstub failure
}

@test "failed to stop td-agent (redhat)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  cat <<SH > "${TMP}/etc/sysconfig/td-agent"
STOPTIMEOUT=3
SH

  stub kill "1234 : true" \
            "-0 1234 : true" \
            "-0 1234 : true" \
            "-0 1234 : true"
  stub sleep "1 : true"
  stub failure "false"

  run_service stop
  assert_output <<EOS
Shutting down td-agent: Timeout error occurred trying to stop td-agent...
EOS
  assert_failure
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub kill
  unstub failure
}

@test "stop td-agent by name successfully (redhat)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  stub killproc "td-agent : true"
  stub success "true"

  run_service stop
  assert_output <<EOS
Shutting down td-agent: 
EOS
  assert_success
  [ ! -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub killproc
  unstub success
}

@test "stop td-agent by custom name successfully (redhat)" {
  rm -f "${TMP}/var/run/td-agent/custom_prog.pid"
  touch "${TMP}/var/lock/subsys/custom_prog"
  cat <<EOS > "${TMP}/etc/sysconfig/td-agent"
prog="custom_prog"
EOS

  stub killproc "custom_prog : true"
  stub success "true"

  run_service stop
  assert_output <<EOS
Declaring \$prog in ${TMP}/etc/sysconfig/td-agent for customizing \$PIDFILE has been deprecated. Use \$AGENT_PID_FILE instead.
Shutting down td-agent: 
EOS
  assert_success
  [ ! -f "${TMP}/var/lock/subsys/custom_prog" ]

  unstub killproc
  unstub success
}

@test "failed to stop td-agent by name (redhat)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  touch "${TMP}/var/lock/subsys/td-agent"

  stub killproc "td-agent : false"
  stub failure "false"

  run_service stop
  assert_output <<EOS
Shutting down td-agent: 
EOS
  assert_failure
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub killproc
  unstub failure
}
