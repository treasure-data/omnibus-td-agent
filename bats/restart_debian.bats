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
  stub killproc "true"
  stub_path /sbin/start-stop-daemon "echo started"
  stub log_success_msg "td-agent : true"

  run_service restart
  assert_output <<EOS
Restarting td-agent: started
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub killproc
  unstub_path /sbin/start-stop-daemon
  unstub log_success_msg
}

@test "failed to restart td-agent due to stop failure (debian)" {
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

@test "failed to restart td-agent by configuration test failure (debian)" {
  stub_path /usr/sbin/td-agent "false"
  stub log_failure_msg "td-agent : true"

  run_service restart
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub log_failure_msg
}

@test "failed to restart td-agent due to start failure (debian)" {
  rm -f "${TMP}/var/run/td-agent/td-agent.pid"
  stub_path /usr/sbin/td-agent "true"
  stub killproc "true"
  stub_path /sbin/start-stop-daemon "false"
  stub log_failure_msg "td-agent : true"

  run_service restart
  assert_output <<EOS
Restarting td-agent: 
EOS
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub killproc
  unstub_path /sbin/start-stop-daemon
  unstub log_failure_msg
}

@test "restart should success even if the previous process has already stopped (debian)" {
  echo 1234 > "${TMP}/var/run/td-agent/td-agent.pid"

  stub_path /usr/sbin/td-agent "true"
  stub kill "-TERM 1234 : false" \
            "-0 1234 : false"
  stub_path /sbin/start-stop-daemon "echo started"
  stub log_success_msg "td-agent : true"

  run_service restart
  assert_output <<EOS
Restarting td-agent: started
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub kill
  unstub_path /sbin/start-stop-daemon
  unstub log_success_msg
}
