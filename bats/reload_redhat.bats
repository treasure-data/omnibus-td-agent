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

@test "reload td-agent successfully (redhat)" {
  stub_path /usr/sbin/td-agent "true"
  stub killproc "echo; for arg; do echo \"  \$arg\"; done"

  run_service reload
  assert_output <<EOS
Reloading td-agent: 
  ${TMP}/opt/td-agent/embedded/bin/ruby
  -HUP
EOS
  assert_success

  unstub_path /usr/sbin/td-agent
  unstub killproc
}

@test "failed to reload td-agent (redhat)" {
  stub_path /usr/sbin/td-agent "true"
  stub killproc "false"

  run_service reload
  assert_output <<EOS
Reloading td-agent: 
EOS
  assert_failure

  unstub_path /usr/sbin/td-agent
  unstub killproc
}

@test "failed to reload td-agent by configuration test failure (redhat)" {
  stub_path /usr/sbin/td-agent "false"

  run_service reload
  assert_failure

  unstub_path /usr/sbin/td-agent
}
