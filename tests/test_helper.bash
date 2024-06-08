#!/usr/bin/env bats
# shellcheck disable=SC2034

load-helpers() {
  load "${BASHABLE_GIT_ROOT}/vendor/bats-assert/load"
  load "${BASHABLE_GIT_ROOT}/vendor/bats-file/load"
  load "${BASHABLE_GIT_ROOT}/vendor/bats-support/load"
}

BASHABLE_GIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export BASHABLE_GIT_ROOT

load-bashable() {
  local library=$1
  load "${BASHABLE_GIT_ROOT}/lib/${library}"
}

fake-tty() {
  "${BASHABLE_GIT_ROOT}/tests/test_helper/pseudo-tty" "$@"
}
