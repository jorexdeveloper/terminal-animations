#!/usr/bin/bash

################################################################################
#                                                                              #
#     LA, version 2023-1.0                                                     #
#                                                                              #
#     Displays a loading animation.                                            #
#                                                                              #
#     Copyright (C) 2023  Jore <https://github.com/jorexdeveloper>             #
#                                                                              #
#     This program is free software: you can redistribute it and/or modify     #
#     it under the terms of the GNU General Public License as published by     #
#     the Free Software Foundation, either version 3 of the License, or        #
#     (at your option) any later version.                                      #
#                                                                              #
#     This program is distributed in the hope that it will be useful,          #
#     but WITHOUT ANY WARRANTY; without even the implied warranty of           #
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
#     GNU General Public License for more details.                             #
#                                                                              #
#     You should have received a copy of the GNU General Public License        #
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.   #
#                                                                              #
################################################################################

################################################################################
#                                FUNCTIONS                                     #
################################################################################

_main() {
	local anim=${_default_anim}
	local time=${_default_anim_time}
	if [ ${#} -gt 0 ]; then
		while getopts ":a:t:m:M:d:n:k:vh" opt; do
			case "${opt}" in
			a)
				if [ "${OPTARG}" == "list" ]; then
					_print_anim_list
					return
				fi
				local anim_exists=false
				for anim in "${_anim_list[@]}"; do
					if [ "${OPTARG}" == "${anim}" ]; then
						anim_exists=true
						break
					fi
				done
				if ${anim_exists}; then
					anim="${OPTARG}"
				else
					_print_error_exit "Unknown animation '${OPTARG}'" 1
				fi
				;;
			t)
				local time="${OPTARG}"
				;;
			m)
				local pre="${OPTARG}"
				;;
			M)
				local post="${OPTARG}"
				;;
			d)
				local duration="${OPTARG}"
				;;
			n)
				local repeat="${OPTARG}"
				;;
			k)
				_stop_anim "${OPTARG}"
				return
				;;
			v)
				_print_version
				return
				;;
			h)
				_print_usage
				return
				;;
			:)
				case "${OPTARG}" in
				k)
					_stop_anim
					return
					;;
				*)
					_print_error_exit "Option '${OPTARG}' requires an argument" 0
					;;
				esac
				;;
			?)
				_print_error_exit "Unrecognized option '${OPTARG}'" 0
				;;
			esac
		done
		shift $((${OPTIND} - 1))
	fi
	if [ "${#}" -gt 0 ]; then
		_print_error_exit "Too many arguments"
	fi
	anim="_anim_${anim}[@]"
	ANIMATION_FRAMES=("${!anim}")
	ANIMATION_INTERVAL=${time}
	stty -echo # Hide input
	tput civis # Hide cursor
	trap "_stop_anim; return" SIGINT
	if [ -n "${repeat}" ]; then
		ANIMATION_REPEAT=${repeat}
		_start_anim "${pre}" "${post}"
		_stop_anim
		return
	else
		_start_anim "${pre}" "${post}" &
	fi
	ANIMATION_PID=${!}
	if [ -n "${duration}" ]; then
		sleep ${duration}
		_stop_anim
	fi
	trap - SIGINT
}

_stop_anim() {
	if [ -n "${1}" ]; then
		local pid=${1}
	elif [ -n "${ANIMATION_PID}" ]; then
		local pid=${ANIMATION_PID}
	fi
	[ -n "${pid}" ] && kill "${pid}" &>/dev/null
	_clear_line
	tput cnorm
	stty echo
}

_start_anim() {
	while true; do
		for frame in "${ANIMATION_FRAMES[@]}"; do
			printf "\r%s" "${1}${frame}${2}"
			sleep ${ANIMATION_INTERVAL}
		done
		if [ -n "${ANIMATION_REPEAT}" ]; then
			ANIMATION_REPEAT=$((${ANIMATION_REPEAT} - 1))
			[ ${ANIMATION_REPEAT} -eq 0 ] && return
		fi
	done
}

_print_mesg() {
	local pre
	local post
	case "${2}" in
	n)
		pre="\n"
		;;
	N)
		post="\n"
		;;
	esac
	printf "${pre}${1}${post}\n"
}

_clear_line() {
	local spaces=
	local columns=$(stty size | cut -d " " -f 2)
	while [ ${columns} -gt 0 ]; do
		spaces+=" "
		columns=$((${columns} - 1))
	done
	printf "\r${spaces}\r"
}

_print_usage() {
	_print_mesg "Usage: ${_SCRIPT_REPOSITORY_} [OPTION]..."
	_print_mesg "Display a loading animation"
	_print_mesg "Options:" n
	_print_mesg "  -a NAME | list"
	_print_mesg "                  Display animation NAME. Use 'list' to see a list"
	_print_mesg "                  of available animations (default=${_default_anim})"
	_print_mesg "  -t TIME[SUFFIX]"
	_print_mesg "                  Use TIME as animation time (default=${_default_anim_time})"
	_print_mesg "  -m TEXT"
	_print_mesg "                  Display TEXT on same line before the animation"
	_print_mesg "  -M TEXT"
	_print_mesg "                  Display TEXT on same line after the animation"
	_print_mesg "  -d TIME[SUFFIX]"
	_print_mesg "                  Display the animation for duration TIME and exit"
	_print_mesg "  -n N"
	_print_mesg "                  Play animation N times and exit"
	_print_mesg "  -h"
	_print_mesg "                  Print this message and exit"
	_print_mesg "  -v"
	_print_mesg "                  Print Script version and exit"
	_print_mesg "For TIME values, SUFFIX may be one of 's' (default), 'm', 'h', 'd'" n
	_print_mesg "See sleep(1) for more information"
	_print_mesg "Global variable ANIMATION_PID is used if PID not supplied with -k" n
	_print_mesg "Documentation: ${U}${_AUTHOR_GITHUB_}/${_SCRIPT_REPOSITORY_}${NU}" n
}

_print_version() {
	_print_mesg "${_SCRIPT_REPOSITORY_}, version ${_SCRIPT_VERSION_}"
	_print_mesg "Copyright (C) 2023 ${_AUTHOR_NAME_} <${U}${_AUTHOR_GITHUB_}${NU}>"
	_print_mesg "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>"
	_print_mesg "This is free software; you are free to change and redistribute it"
	_print_mesg "There is NO WARRANTY, to the extent permitted by law"
}

_print_anim_list() {
	_print_mesg "Available animations:"
	local anim
	for anim in "${_anim_list[@]}"; do
		_print_mesg "${anim}"
	done
}

_print_error_exit() {
	local post
	case "${2}" in
	0)
		post=". Try '-h' for more information"
		;;
	1)
		post=". Try '-a list' for list of available animations"
		;;
	esac
	printf "${1}${post}\n"
	exit 1
}

################################################################################
#                                ENTRY POINT                                   #
################################################################################

# Author info
_AUTHOR_NAME_="Jore"
_AUTHOR_GITHUB_="https://github.com/jorexdeveloper"

# Script info
_SCRIPT_VERSION_="2023-1.0"
_SCRIPT_REPOSITORY_="loading-anim"

# Script variables
_default_anim="standard"
_default_anim_time=0.2s
_anim_list=("arrow" "arrow2" "arrow_fill" "bar" "bar2" "bar_fill" "bit" "block" "block_alt" "bomb" "bounce" "braille" "braille2" "breathe" "bubble" "camera" "camera2" "classic" "clock" "earth" "eyes" "face" "face2" "fireworks" "future" "lunar" "metro" "modern" "modern2" "monkey" "pong" "pulse_blue" "pulse_orange" "quarter" "semi" "snake" "soccer" "standard" "standard2" "trigram" "wave")
# Animations
_anim_arrow=('↑' '↗' '→' '↘' '↓' '↙' '←' '↖')
_anim_arrow2=('◢' '◣' '◤' '◥')
_anim_arrow_fill=('▹▹▹▹▹' '▸▹▹▹▹' '▹▸▹▹▹' '▹▹▸▹▹' '▹▹▹▸▹' '▹▹▹▹▸' '▹▹▹▹▹' '▹▹▹▹▹' '▹▹▹▹▹' '▹▹▹▹▹' '▹▹▹▹▹' '▹▹▹▹▹' '▹▹▹▹▹')
_anim_bar=('[    ]' '[#   ]' '[##  ]' '[### ]' '[ ###]' '[  ##]' '[   #]')
_anim_bar2=('[    ]' '[=   ]' '[==  ]' '[=== ]' '[ ===]' '[  ==]' '[   =]')
_anim_bar_fill=('█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '███▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '█████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '███████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '█████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '██████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '███████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '█████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '██████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '███████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '████████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '█████████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '██████████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒' '███████████████████▒▒▒▒▒▒▒▒▒▒▒▒▒' '████████████████████▒▒▒▒▒▒▒▒▒▒▒▒' '█████████████████████▒▒▒▒▒▒▒▒▒▒▒' '██████████████████████▒▒▒▒▒▒▒▒▒▒' '███████████████████████▒▒▒▒▒▒▒▒▒' '████████████████████████▒▒▒▒▒▒▒▒' '█████████████████████████▒▒▒▒▒▒▒' '██████████████████████████▒▒▒▒▒▒' '███████████████████████████▒▒▒▒▒' '████████████████████████████▒▒▒▒' '█████████████████████████████▒▒▒' '██████████████████████████████▒▒' '███████████████████████████████▒' '████████████████████████████████')
_anim_bit=('(●)' '(⚬)')
_anim_block=('▁' '▂' '▃' '▄' '▅' '▆' '▇' '█' '█' '▇' '▆' '▅' '▄' '▃' '▂' '▁')
_anim_block2=('▏' '▎' '▍' '▌' '▋' '▊' '▉' '▉' '▊' '▋' '▌' '▍' '▎' '▏')
_anim_bomb=('💣   ' ' 💣  ' '  💣 ' '   💣' '   💣' '   💣' '   💣' '   💣' '   💥' '    ' '    ')
_anim_bounce=('.' '·' '·')
_anim_braille=('⠁' '⠂' '⠄' '⡀' '⢀' '⠠' '⠐' '⠈')
_anim_braille2=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
_anim_breathe=('  ()  ' ' (  ) ' '(    )' ' (  ) ')
_anim_bubble=('·' 'o' 'O' 'O' 'o' '·')
_anim_camera=('📷' '📷' '📷' '📷' '📷' '📷' '📷' '📷' '📸' '📷' '📸')
_anim_camera2=('📷 ' '📷 ' '📷 ' '📷 ' '📷 ' '📷 ' '📷 ' '📷 ' '📸✨' '📷 ' '📸✨')
_anim_classic=('-' '\' '|' '/')
_anim_clock=('🕛' '🕐' '🕑' '🕒' '🕓' '🕔' '🕕' '🕖' '🕗' '🕘' '🕙' '🕚')
_anim_earth=('🌍' '🌎' '🌏')
_anim_eyes=('◡◡ ⊙⊙' '⊙⊙' '◠◠')
_anim_face=('🤢' '🤢' '🤮')
_anim_face2=('😐' '😀' '😍' '🙄' '😒' '😨' '😡')
_anim_fireworks=('⢀' '⠠' '⠐' '⠈' '*' '*' ' ')
_anim_future=('┤' '┴' '├' '┬')
_anim_lunar=('🌕' '🌖' '🌗' '🌘' '🌑' '🌒' '🌓' '🌔')
_anim_metro=('▰▱▱▱▱▱▱' '▰▰▱▱▱▱▱' '▰▰▰▱▱▱▱' '▱▰▰▰▱▱▱' '▱▱▰▰▰▱▱' '▱▱▱▰▰▰▱' '▱▱▱▱▰▰▰' '▱▱▱▱▱▰▰' '▱▱▱▱▱▱▰' '▱▱▱▱▱▱▱' '▱▱▱▱▱▱▱' '▱▱▱▱▱▱▱' '▱▱▱▱▱▱▱')
_anim_modern=('●     ' ' ●    ' '  ●   ' '   ●  ' '    ● ' '     ●' '    ● ' '   ●  ' '  ●   ' ' ●    ')
_anim_modern2=('∙∙∙' '●∙∙' '∙●∙' '∙∙●')
_anim_monkey=('🙉' '🙈' '🙊' '🙈')
_anim_pong=('▐⠂       ▌' '▐⠈       ▌' '▐ ⠂      ▌' '▐ ⠠      ▌' '▐  ⡀     ▌' '▐  ⠠     ▌' '▐   ⠂    ▌' '▐   ⠈    ▌' '▐    ⠂   ▌' '▐    ⠠   ▌' '▐     ⡀  ▌' '▐     ⠠  ▌' '▐      ⠂ ▌' '▐      ⠈ ▌' '▐       ⠂▌' '▐       ⠠▌' '▐       ⡀▌' '▐      ⠠ ▌' '▐      ⠂ ▌' '▐     ⠈  ▌' '▐     ⠂  ▌' '▐    ⠠   ▌' '▐    ⡀   ▌' '▐   ⠠    ▌' '▐   ⠂    ▌' '▐  ⠈     ▌' '▐  ⠂     ▌' '▐ ⠠      ▌' '▐ ⡀      ▌' '▐⠠       ▌')
_anim_pulse_blue=('🔹' '🔷' '🔵' '🔵' '🔷')
_anim_pulse_orange=('🔸' '🔶' '🟠' '🟠' '🔶')
_anim_quarter=('▖' '▘' '▝' '▗')
_anim_semi=('◐' '◓' '◑' '◒')
_anim_snake=('[=     ]' '[~<    ]' '[~~=   ]' '[~~~<  ]' '[ ~~~= ]' '[  ~~~<]' '[   ~~~]' '[    ~~]' '[     ~]' '[      ]')
_anim_soccer=(' 👧⚽️       👦' '👧  ⚽️      👦' '👧   ⚽️     👦' '👧    ⚽️    👦' '👧     ⚽️   👦' '👧      ⚽️  👦' '👧       ⚽️👦 ' '👧      ⚽️  👦' '👧     ⚽️   👦' '👧    ⚽️    👦' '👧   ⚽️     👦' '👧  ⚽️      👦')
_anim_standard=('.  ' '.. ' '...' '   ')
_anim_standard2=('.  ' '.. ' '...' ' ..' '  .' '   ')
_anim_trigram=('☰' '☱' '☳' '☶' '☴')
_anim_wave=('𓃉𓃉𓃉' '𓃉𓃉∘' '𓃉∘°' '∘°∘' '°∘𓃉' '∘𓃉𓃉')

# Begin
_main "${@}"
