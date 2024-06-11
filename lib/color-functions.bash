#!/usr/bin/env bash

# @file color-functions.bash
# @brief Color functions
#

# A guard to prevent re-sourcing.
if [[ -n ${_bashables_color_functions_is_sourced-} ]]; then
  return
fi
_bashables_color_functions_is_sourced=true

# convert_true_color_to_256 converts a true color to a 256 color suitable for
# use with \e[38;5;Qm and \e[48;5;Qm escape codes (replace Q with the returned
# value).
#
# Warning: Slow. Use this to discover a color and then hard-code it.
#
# @arg $1 number Red value.
# @arg $2 number Green value.
# @arg $3 number Blue value.
# @stdout The 256 color code as a number.
convert_true_color_to_256() {
  awk "BEGIN { printf \"%d\\n\", ($1 * 6.0 / 256) * 36 + ($2 * 6.0 / 256) * 6 + ($3 * 6.0 / 256) }"
}
