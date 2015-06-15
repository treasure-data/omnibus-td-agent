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

  run_service start
  assert_output <<EOS
Starting td-agent: 
  --pidfile=${TMP}/var/run/td-agent/td-agent.pid
  --user
  td-agent
  ${TMP}/opt/td-agent/embedded/bin/ruby
  ${TMP}/usr/sbin/td-agent
  --group
  td-agent
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
  --daemon
  ${TMP}/var/run/td-agent/td-agent.pid
EOS
  assert_success
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub daemon
}

@test "start td-agent with custom name successfully (redhat)" {
  rm -f "${TMP}/var/run/td-agent/custom_prog.pid"
  cat <<EOS > "${TMP}/etc/sysconfig/td-agent"
name="custom_name"
process_bin="${TMP}/path/to/custom_process_bin"
prog="custom_prog"
EOS

  stub daemon "echo; for arg; do echo \"  \$arg\"; done"

  run_service start
  assert_output <<EOS
Warning: Declaring \$name in ${TMP}/etc/sysconfig/td-agent has been deprecated. Use \$TD_AGENT_NAME instead.
Warning: Declaring \$prog in ${TMP}/etc/sysconfig/td-agent for customizing \$PIDFILE has been deprecated. Use \$TD_AGENT_PID_FILE instead.
Warning: Declaring \$process_bin in ${TMP}/etc/sysconfig/td-agent has been deprecated. Use \$TD_AGENT_RUBY instead.
Starting custom_name: 
  --pidfile=${TMP}/var/run/td-agent/custom_prog.pid
  --user
  td-agent
  ${TMP}/path/to/custom_process_bin
  ${TMP}/usr/sbin/td-agent
  --group
  td-agent
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
  --daemon
  ${TMP}/var/run/td-agent/custom_prog.pid
EOS
  assert_success
  [ -f "${TMP}/var/lock/subsys/custom_prog" ]

  unstub daemon
}

@test "start td-agent with custom configuration successfully (redhat)" {
  rm -f "${TMP}/path/to/td-agent.pid"
  cat <<EOS > "${TMP}/etc/sysconfig/td-agent"
DAEMON_ARGS="--user nobody"
PIDFILE="${TMP}/path/to/td-agent.pid"
TD_AGENT_ARGS="/path/to/td-agent -vv --group nogroup --log /path/to/td-agent.log"
EOS

  stub daemon "echo; for arg; do echo \"  \$arg\"; done"

  run_service start
  assert_output <<EOS
Starting td-agent: 
  --pidfile=${TMP}/path/to/td-agent.pid
  --user
  nobody
  ${TMP}/opt/td-agent/embedded/bin/ruby
  /path/to/td-agent
  -vv
  --group
  nogroup
  --log
  /path/to/td-agent.log
  --daemon
  ${TMP}/path/to/td-agent.pid
EOS
  assert_success
  [ -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub daemon
}

@test "failed to start td-agent (redhat)" {
  stub daemon "false"

  run_service start
  assert_output <<EOS
Starting td-agent: 
EOS
  assert_failure
  [ ! -f "${TMP}/var/lock/subsys/td-agent" ]

  unstub daemon
}
