#!/usr/bin/env bash
# shellcheck disable=SC2034

# Functions to display output.

# A guard to prevent re-sourcing.
if [[ -n ${_bashables_rant_is_sourced-} ]]; then
  return
fi
readonly _bashables_rant_is_sourced=true

source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
source "$(dirname "${BASH_SOURCE[0]}")/color.bash"

# By default, the debugging flag is "BASHABLE_DEBUG" but may be set to
# something else.
BASHABLE_DEBUG_FLAG=${BASHABLE_DEBUG_FLAG:-"BASHABLE_DEBUG"}

# Normalize the debug flag variable.
normalize_flag_variable "${BASHABLE_DEBUG_FLAG}"

# Terminates immediately with a message.
#
# This calls `exit 1` and will exit the shell.
#
# @param {string} $* - Message to display.
die() {
  echo "${red}FATAL${reset}: ${yellow}$*${reset}" >&2
  exit 1
}

# is_debug returns true if we're running in a debug mode.
#
# Debug mode is based on the variable name in the variable BASHABLE_DEBUG_FLAG.
#
# @return {boolean} True if debugging is enabled.
is_debug() {
  is_flag_variable_true "${BASHABLE_DEBUG_FLAG}"
}

# debug prints output if debugging is turned on.
#
# @param {string} $* - The message to display.
debug() {
  if is_debug; then
    echo "${grey}DEBUG${reset}: $*" >&2
  fi
}

if bash_is_at_least 5.2; then
  readonly _bashables_q_format_char="Q"
else
  readonly _bashables_q_format_char="q"
fi

# q will shell quote the arguments. Similar to Ruby's built-in 'shellwords'.
#
# @param {string} $variable_name - The name of the variable to store the result.
# @param {string} $* - Arguments to quote.
q-to-variable() {
  # If we're bash 5.2 or later, we can use the new
  # printf formatter %Q to quote the arguments.
  local variable_name=$1 string
  shift

  # shellcheck disable=SC2059
  printf -v string -- "%${_bashables_q_format_char} " "$@"
  printf -v "${variable_name}" -- "%s" "${string%?}" # strip last space
}

# q will shell quote the arguments. Similar to Ruby's built-in 'shellwords'.
#
# @param {string} $* - Arguments to quote.
# @output {string} - The quoted arguments.
q() {
  local string
  q-to-variable string "$@"
  printf "%s" "${string}"
}

# repeat-string-to-variable will repeat a string a number of times and store it
# in a variable.
#
# @param {string} $variable_name - The name of the variable to store the result.
# @param {number} $count - The number of times to repeat the string.
# @param {string} $string - The string to repeat.
repeat-string-to-variable() {
  local variable_name=$1 string=$3
  local count=$2

  # 0 (or less) means an empty string
  if ((count <= 0)); then
    printf -v "${variable_name}" -- ""
    return
  fi

  # escape slash (\) characters.
  string=${string//\\/\\\\}

  # escape % characters.
  string=${string//%/%%}

  # shellcheck disable=SC2046
  printf -v "${variable_name}" -- "${string}"'%.s' $(eval "echo {1.."$((count))"}" || :)
}

# repeat-string will repeat a string a number of times.
#
# @param {number} $1 - The number of times to repeat the string.
# @param {string} $2 - The string to repeat.
repeat-string() {
  local var
  repeat-string-to-variable var "$1" "$2"
  printf -- "%s" "${var}"
}

# This might be replaced with a unit-test frame work.
if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
  echo
  echo "This script is meant to be sourced, not executed."
fi

# EOF
