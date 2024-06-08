#!/usr/bin/env bats
# shellcheck disable=SC2034

load-helpers() {
  load "${BASHABLE_GIT_ROOT}/vendor/bats-assert-2.1.0/load"
  load "${BASHABLE_GIT_ROOT}/vendor/bats-file-0.4.0/load"
  load "${BASHABLE_GIT_ROOT}/vendor/bats-support-0.3.0/load"
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
