#!/usr/bin/env bats

setup() {
  load "test_helper"
  load-helpers
}

@test "faketty returns the status code of the command" {
  run fake-tty true
  assert_success
  assert_output ""

  run fake-tty sh -c "exit 2"
  assert_failure 2
  assert_output ""
}

@test "BASHABLE_GIT_ROOT is a directory" {
  [[ -n ${BASHABLE_GIT_ROOT} ]]
  [[ -d ${BASHABLE_GIT_ROOT} ]]
}

# vim: set filetype=sh :
