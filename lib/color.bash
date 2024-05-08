#!/usr/bin/env bash
# shellcheck disable=SC2034

# Color variables for 256 & 24 bit xterm-style terminals.

# A guard to prevent re-sourcing.
if [[ -n ${_bashables_color_is_sourced-} ]]; then
	return
fi
_bashables_color_is_sourced=true

if { { [[ ${USE_COLOR:-auto} == "auto" ]] && [[ -t 2 ]] && [[ -t 1 ]]; } ||
	[[ ${USE_COLOR:-auto} == "always" ]]; } && [[ ${USE_COLOR:-auto} != "never" ]]; then

	# 256 color
	declare -r black=$'\e[30m' red=$'\e[31m' green=$'\e[32m'
	declare -r yellow=$'\e[33m' blue=$'\e[34m' magenta=$'\e[35m'
	declare -r cyan=$'\e[36m' white=$'\e[37m' grey=$'\e[90m'

	declare -r black_bg=$'\e[40m' red_bg=$'\e[41m' green_bg=$'\e[42m'
	declare -r yellow_bg=$'\e[43m' blue_bg=$'\e[44m' magenta_bg=$'\e[45m'
	declare -r cyan_bg=$'\e[46m' white_bg=$'\e[47m'

	declare -r bold=$'\e[1m' reset=$'\e[0m'
else
	# no color
	declare -r black='' red='' green='' yellow='' blue='' magenta=''
	declare -r cyan='' white='' grey='' bold='' reset=''

	declare -r black_bg='' red_bg='' green_bg='' yellow_bg='' blue_bg='' magenta_bg=''
	declare -r cyan_bg='' white_bg=''

fi

# This might be replaced with a unit-test frame work.
if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
	echo "${bold}Example Colors ${COLORTERM:-"256 color"}${reset}"

	for color in black red green yellow blue magenta cyan white grey; do
		if [[ ${color} == "black" ]]; then
			bg=${white_bg}
		else
			bg=${black_bg}
		fi
		echo -n " ${reset}${!color}${bg}This is \$${color}."
		echo -n " ${reset}${!color}${bg}${bold}This is \$bold \$${color}."
		echo "${reset}"
	done
fi
# EOF
