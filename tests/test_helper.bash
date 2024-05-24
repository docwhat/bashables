#!/usr/bin/env bats
# shellcheck disable=SC2034

load-helpers() {
  load test_helper/bats-assert-2.1.0/load
  load test_helper/bats-file-0.4.0/load
  load test_helper/bats-support-0.3.0/load
}

BASHABLE_GIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export BASHABLE_GIT_ROOT

load-bashable() {
  local library=$1
  load "${BASHABLE_GIT_ROOT}/lib/${library}"
}

fake-tty() {
  local tmp err cmd

  # Create a temporary file for storing the status code
  tmp=$(mktemp) || return 99

  # Ensure it worked or fail with status 99
  if [[ -z ${tmp} ]]; then
    return 99
  fi

  # Produce a script that runs the command provided to faketty as
  # arguments and stores the status code in the temporary file
  cmd="$(printf '%q ' "$@"); echo \$? > $(printf '%q' "${tmp}")"

  # Run the script through /bin/sh with fake tty
  if [[ "$(uname -s || :)" == "Darwin" ]]; then
    # MacOS
    script -Fq /dev/null /bin/sh -c "${cmd}"
  else
    script -qfc "/bin/sh -c $(printf "%q " "${cmd}")" /dev/null
  fi

  # Ensure that the status code was written to the temporary file or
  # fail with status 99
  if ! [[ -s ${tmp} ]]; then
    return 99
  fi

  # Collect the status code from the temporary file
  err=$(cat "${tmp}")

  # Remove the temporary file
  rm -f "${tmp}"

  # Return the status code
  return "${err}"
}
