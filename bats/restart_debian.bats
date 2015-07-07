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

@test "restart td-agent successfully (debian)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub_path /sbin/start-stop-daemon "echo; echo stopped successfully" \
                                    "echo started"
  stub log_success_msg "td-agent : true"

  run_service restart
  assert_output <<EOS
Restarting td-agent: 
stopped successfully
started
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub_path /sbin/start-stop-daemon
  unstub log_success_msg
}

@test "restart td-agent regardless of stop failure (debian)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub_path /sbin/start-stop-daemon "echo; echo failed to stop; false" \
                                    "echo started"
  stub log_success_msg "td-agent : true"

  run_service restart
  assert_output <<EOS
Restarting td-agent: 
failed to stop
started
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub_path /sbin/start-stop-daemon
  unstub log_success_msg
}

@test "failed to restart td-agent by configuration test failure (debian)" {
  stub_path /usr/sbin/td-agent "false"
  stub log_failure_msg "td-agent : false"

  run_service restart
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub log_failure_msg
}

#@test "failed to restart td-agent by stale process (debian)" {
#  stub_path /usr/sbin/td-agent "true"
#  stub_path /sbin/start-stop-daemon "echo; echo stopped successfully"
#  stub kill "-0 1234 : true"
#  stub log_failure_msg "td-agent : false"
#
#  run_service restart
#  assert_output <<EOS
#Restarting td-agent: 
#stop
#stopped successfully
#EOS
#  assert_failure
#
#  unstub_path /usr/sbin/td-agent
#  unstub_path /sbin/start-stop-daemon
#  unstub kill
#  unstub log_failure_msg
#}

@test "failed to restart td-agent by start failure (debian)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub_path /sbin/start-stop-daemon "echo; echo stopped successfully" \
                                    "echo failed to start; false"
  stub log_failure_msg "td-agent : true"

  run_service restart
  assert_output <<EOS
Restarting td-agent: 
stopped successfully
failed to start
EOS
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub_path /sbin/start-stop-daemon
  unstub log_failure_msg
}
