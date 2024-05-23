#!/usr/bin/env bats

setup() {
  load "test_helper"
  load-helpers
  load-bashable rant
}

@test "die() prints message and exits" {
  run die "frobnitz"
  assert_failure
  assert_output "FATAL: frobnitz"
}

@test "is_debug() returns false when \${!BASHABLE_DEBUG_FLAG} is not set" {
  # shellcheck disable=SC2030
  export BASHABLE_DEBUG_FLAG=mouse
  unset mouse
  refute is_debug
}

@test "is_debug() returns true when \${!BASHABLE_DEBUG_FLAG} is truthy" {
  # shellcheck disable=SC2030,SC2031
  export BASHABLE_DEBUG_FLAG=mouse
  # shellcheck disable=SC2034
  for mouse in 1 true yes t y; do
    assert is_debug
  done
}

@test "is_debug() returns false when \${!BASHABLE_DEBUG_FLAG} is falsy" {
  # shellcheck disable=SC2030,SC2031
  export BASHABLE_DEBUG_FLAG=mouse
  # shellcheck disable=SC2034
  for mouse in 0 false f n no flibbit; do
    refute is_debug
  done
}

@test "debug() prints nothing when debugging is off" {
  # shellcheck disable=SC2317
  is_debug() { return 1; }
  run debug "hello"
  assert_success
  refute_output
}

@test "debug() prints message when debugging is on" {
  is_debug() { return 0; }
  run debug "hello"
  assert_success
  assert_output "DEBUG: hello"
}

@test "q-to-variable() shell quotes the arguments" {
  result=original-value
  q-to-variable result "hello world"
  # Three variations that show how a space could be quoted.
  assert_regex "${result}" '^('"'"'hello world'"'"'|"hello world"|hello\\ world)$'
}

@test "repeat-string() 0 times" {
  run repeat-string 0 "hello"
  assert_success
  refute_output
}

@test "repeat-string() 1 time" {
  run repeat-string 1 "hello"
  assert_success
  assert_output "hello"
}

@test "repeat-string() 2 times" {
  run repeat-string 2 "hello"
  assert_success
  assert_output "hellohello"
}

@test "repeat-string-to-variable() 0 times" {
  result=original-value
  repeat-string-to-variable result 0 "hello"
  assert_equal "${result}" ""
}

@test "repeat-string-to-variable() 1 time" {
  result=original-value
  repeat-string-to-variable result 1 "hello"
  assert_equal "${result}" "hello"
}

@test "repeat-string-to-variable() 3 times" {
  result=original-value
  repeat-string-to-variable result 3 "hello"
  assert_equal "${result}" "hellohellohello"
}

# vim: set filetype=sh :
