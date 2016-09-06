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

@test "start td-agent with backward-compatible configuration (redhat)" {
  mkdir -p "${TMP}/path/to"
  touch "${TMP}/path/to/custom_process_bin"
  chmod +x "${TMP}/path/to/custom_process_bin"
  rm -f "${TMP}/var/run/td-agent/custom_prog.pid"
  cat <<EOS > "${TMP}/etc/sysconfig/td-agent"
name="custom_name"
process_bin="${TMP}/path/to/custom_process_bin"
prog="custom_prog"
EOS

  stub daemon "echo; for arg; do echo \"  \$arg\"; done"
  stub log_success_msg "custom_name : true"

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
  --log
  ${TMP}/var/log/td-agent/td-agent.log
  --use-v1-config
  --group
  td-agent
  --daemon
  ${TMP}/var/run/td-agent/custom_prog.pid
EOS
  assert_success
  [ -f "${TMP}/var/lock/subsys/custom_prog" ]

  unstub daemon
  unstub log_success_msg
}

@test "stop td-agent with backward-compatible configuration (redhat)" {
  rm -f "${TMP}/var/run/td-agent/custom_prog.pid"
  touch "${TMP}/var/lock/subsys/custom_prog"
  cat <<EOS > "${TMP}/etc/sysconfig/td-agent"
prog="custom_prog"
EOS

  stub killproc "custom_prog : true"
  stub log_success_msg "td-agent : true"

  run_service stop
  assert_output <<EOS
Warning: Declaring \$prog in ${TMP}/etc/sysconfig/td-agent for customizing \$PIDFILE has been deprecated. Use \$TD_AGENT_PID_FILE instead.
Stopping td-agent: 
EOS
  assert_success
  [ ! -f "${TMP}/var/lock/subsys/custom_prog" ]

  unstub killproc
  unstub log_success_msg
}
