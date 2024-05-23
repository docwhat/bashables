#!/usr/bin/env bats
# shellcheck disable=SC1003

setup() {
  load "test_helper"
  load-helpers
  load-bashable common
}

@test "has() returns true if the command is in the PATH" {
  run has bash

  refute_output
  assert_success
}

@test "has() returns false if the command is not in the PATH" {
  run has this-command-should-never-exist

  refute_output
  assert_failure
}

@test "bash_is_at_least() returns true if we want a lower version" {
  run bash_is_at_least 1.1
  refute_output
  assert_success
}

@test "bash_is_at_least() returns false if we want a higher" {
  run bash_is_at_least 999.999
  refute_output
  assert_failure
}

@test "normalize_flag_variable() normalizes 't' to 'true'" {
  foo=t
  normalize_flag_variable foo
  assert_equal "${foo}" "true"
}
@test "normalize_flag_variable() normalizes 'f' to 'false'" {
  # shellcheck disable=SC2030
  foo=f
  normalize_flag_variable foo
  assert_equal "${foo}" "false"
}

@test "normalize_flag_variable() exports the variable" {
  unset foo
  normalize_flag_variable foo
  # shellcheck disable=2031
  assert_equal "${foo}" "false"
  bash -c '[[ ${foo} == false ]]'
}

@test "is_flag_variable_true() returns true with truthy flags" {
  local value
  for value in true t 1 y yes; do
    foo=${value}
    run is_flag_variable_true foo
    assert_success
    refute_output
  done
}

@test "is_flag_variable_true() returns false with falsy flags" {
  local value
  for value in false f 0 n no '' nothing bar; do
    foo=${value}
    run is_flag_variable_true foo
    assert_failure
    refute_output
  done
}

# vim: set filetype=sh :
