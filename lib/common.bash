#!/usr/bin/env bash
# shellcheck disable=SC2034

# Common utilities that are useful for all scripts.

# A guard to prevent re-sourcing.
if [[ -n ${_bashables_common_is_sourced-} ]]; then
  return
fi
readonly _bashables_common_is_sourced=true

# Returns true if a command exists in the PATH.
#
# @param {string} $1 - Command to check.
# @return {boolean} True if the command exists.
has() {
  command -v "$1" &>/dev/null
}

# is_macos() returns true if we're running on macOS
# @return {boolean} True if we're running on macOS.
is_macos() {
  [[ ${OSTYPE} == darwin* ]]
}

# is_linux() returns true if we're running on Linux.
# @return {boolean} True if we're running on Linux.
is_linux() {
  [[ ${OSTYPE} == linux* ]]
}

# is_windows() returns true if we're running on Windows.
# @return {boolean} True if we're running on Windows.
is_windows() {
  [[ ${OSTYPE} == msys || ${OSTYPE} == cygwin ]]
}

# Check if the bash version is greater than or equal to
# the major.minor version specified.
#
# @param {string} $1 - The major.minor version to check.
bash_is_at_least() {
  local -r required_major=${1%%.*} required_minor=${1#*.}
  local -r bash_major=${BASH_VERSINFO[0]} bash_minor=${BASH_VERSINFO[1]}

  ((bash_major > required_major || (bash_major == required_major && bash_minor >= required_minor)))
}

# normalize_flag_variable takes the name of an exported variable and
# forces it to be set to 'true' or 'false'.
#
# The values 'true', 't', '1', 'y', and 'yes' are all acceptable as "true".
#
# The variable will be exported.
#
# @param {string} $variable_name - The name of the variable to normalize and export.
normalize_flag_variable() {
  local variable_name=$1
  if is_flag_variable_true "${variable_name}"; then
    export "${variable_name}=true"
  else
    export "${variable_name}=false"
  fi
}

# is_flag_variable_true() returns true if the flag variable is set to 'true'.
#
# @param {string} $variable_name - The name of the flag variable to check.
# @return {boolean} True if the flag variable is set to 'true', 't', '1', 'y', or 'yes'.
is_flag_variable_true() {
  local variable_name=$1
  case "${!variable_name-}" in
  true | t | 1 | y | yes)
    return 0
    ;;
  *)
    return 1
    ;;
  esac
}

if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
  echo
  echo "This script is meant to be sourced, not executed."
fi

# EOF
