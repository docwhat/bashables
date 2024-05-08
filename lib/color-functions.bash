#!/usr/bin/env bash

# Color functions

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
# @param {number} $1 - Red value.
# @param {number} $2 - Green value.
# @param {number} $3 - Blue value.
# @return {number} The 256 color code.
convert_true_color_to_256() {
	awk "BEGIN { printf \"%d\\n\", ($1 * 6.0 / 256) * 36 + ($2 * 6.0 / 256) * 6 + ($3 * 6.0 / 256) }"
}
