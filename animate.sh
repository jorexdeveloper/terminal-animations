#!/bin/bash
# shellcheck disable=SC2155 disable=SC1090

################################################################################
#                                                                              #
#    animate.sh 2025-1.0                                                       #
#                                                                              #
#    Displays a loading animation while executing a command.                   #
#                                                                              #
#    Copyright (C) 2023 Jore <https://github.com/jorexdeveloper>               #
#                                                                              #
#    This program is free software: you can redistribute it and/or modify      #
#    it under the terms of the GNU General Public License as published by      #
#    the Free Software Foundation, either version 3 of the License, or         #
#    (at your option) any later version.                                       #
#                                                                              #
#    This program is distributed in the hope that it will be useful,           #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of            #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             #
#    GNU General Public License for more details.                              #
#                                                                              #
#    You should have received a copy of the GNU General Public License         #
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.    #
#                                                                              #
################################################################################

################################################################################
#                               HELPER FUNCTIONS                               #
################################################################################

# Prints a message with optional coloring.
# Arguments:
#   1. Message to print.
#   2. Color code (r: red, g: green, y: yellow, b: blue, c: cyan). Default: none.
__animations::msg() {
    local color
    case "${2}" in
        r) color="\033[1;31m" ;;
        g) color="\033[1;32m" ;;
        y) color="\033[1;33m" ;;
        b) color="\033[1;34m" ;;
        c) color="\033[1;36m" ;;
        *) color="\033[0m" ;;
    esac
    printf "\r${color}%-${__animations__term_width}s\033[0m\n" "${1}"
}

# Parses command-line options and sets animation and command variables.
# Arguments:
#   Command-line options
#   Remaining arguments are the command to execute.
# Sets:
#   __animations__frames, __animations__prefix, __animations__suffix, __animations__interval, __animations__animation_name, __animations__command, __animations__log_dir, __animations__animations_dir.
__animations::options() {
    if ! args="$(getopt -n "${__animations__program_name}" -o "f:a:i:p:s:A:L:lhv" --long "frames:,animation:,interval:,prefix:,suffix:,animations-dir:,log-dir:,list,help,version" -- "${@}")"; then
        return 1
    fi
    eval set -- "${args}"
    while true; do
        case "${1}" in
            -f | --frames)
                local ifs_old="${IFS}"
                IFS=','
                read -r -a __animations__frames <<<"${2}"
                IFS="${ifs_old}"
                shift 2 && continue
                ;;
            -a | --animation)
                __animations__animation_name="${2}"
                shift 2 && continue
                ;;
            -i | --interval)
                if [[ ! "${2}" =~ ^[+]?([0-9]+)?(\.[0-9]+)?$ ]]; then
                    __animations::msg "${__animations__program_name}: Invalid time interval '${2}'." "r"
                    __animations::msg "Try '${__animations__program_name} --help' for more information."
                    __animations::usage
                    return 1
                fi
                __animations__interval="${2}"
                shift 2 && continue
                ;;
            -p | --prefix)
                __animations__prefix="${2}"
                shift 2 && continue
                ;;
            -s | --suffix)
                __animations__suffix="${2}"
                shift 2 && continue
                ;;
            -A | --animations-dir)
                __animations__animations_dir="$(realpath "${2}")"
                shift 2 && continue
                ;;
            -L | --logs-dir)
                __animations__log_dir="$(realpath "${2}")"
                shift 2 && continue
                ;;
            -l | --list)
                __animations::list
                return 5
                ;;
            -h | --help)
                __animations::usage
                return 5
                ;;
            -v | --version)
                __animations::version
                return 5
                ;;
            --)
                shift && break
                ;;
            *) return 2 ;;
        esac
    done
    __animations__command=("${@}")
}

# Loads the specified animation.
# Variables:
#   __animations__animation_name: Name of the animation to load.
#   __animations__animations_dir: Directory containing animation scripts.
__animations::load() {
    local animation_file="${__animations__animations_dir}/${__animations__animation_name}.sh"
    if [[ -f "${animation_file}" ]]; then
        source "${animation_file}"
    else
        __animations::msg "${__animations__program_name}: Animation '${__animations__animation_name}' not found in '${__animations__animations_dir}' directory." "r"
        __animations::msg "Make sure a file named '${__animations__animation_name}.sh' exists in that directory."
        __animations::msg "Try '${__animations__program_name} --help' for more information."
        return 1
    fi
}

# Starts a background animation.
# Variables:
#   __animations__frames: Array of animation frames.
#   __animations__prefix: Text before the animation.
#   __animations__suffix: Text after the animation.
#   __animations__interval: Time interval between frames.
# Sets:
#   __animations__animation_pid: PID of the animation process.
__animations::start() {
    animate() {
        trap 'printf "\r%-${__animations__term_width}s\r" ""; trap - EXIT' EXIT
        local frame
        while true; do
            for frame in "${__animations__frames[@]}"; do
                printf "\r%-${__animations__term_width}s" "${__animations__prefix}${frame}${__animations__suffix}"
                sleep "${__animations__interval}"
            done
        done
    }
    stty -echo                       # Hide input
    printf "\033[?25l"               # Hide cursor
    animate 2>/dev/null &            # Run animation in the background
    __animations__animation_pid=${!} # Capture the PID of the animation process
    unset -f animate
}

# Stops the background animation and restores terminal settings.
# Arguments:
#   1. Animation PID to stop.
__animations::stop() {
    local pid="${1}"
    if [[ -n "${pid}" ]]; then
        kill "${pid}" &>/dev/null
        wait "${pid}" &>/dev/null
        printf "\033[?25h" # Restore cursor
        stty echo          # Restore input
    fi
}

# Executes the specified command and logs its output.
# Arguments:
#   1. Command to be executed
#   The rest are command arguments
# Variables:
#   __animations__command_name: Name of command being executed
#   __animations__log_file: Path to the log file.
__animations::execute() {
    local log_sep="$(printf '%*s' "25" '' | tr ' ' '=')"
    {
        echo -e "\n"
        echo "${log_sep}"
        echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Command: ${__animations__command_name}"
        echo -n "Arguments: "
        if [[ ${#__animations__command[@]} -gt 1 ]]; then
            echo "${__animations__command[@]:1}"
        else
            echo "none"
        fi
        echo "Animation: ${__animations__animation_name:-default}"
        echo "${log_sep}"
    } >>"${__animations__log_file}"
    interrupted() {
        __animations::stop "${__animations__animation_pid}" &&
            trap - SIGINT
        __animations::msg "${__animations__command_name} interrupted by user." "y"
    }
    __animations::start &&
        trap 'interrupted; return 130' SIGINT
    if "${@}" &>>"${__animations__log_file}"; then
        __animations::stop "${__animations__animation_pid}" &&
            trap - SIGINT
        __animations::msg "${__animations__command_name} is done." "g"
    else
        local exit_code=${?}
        if [[ "${exit_code}" -eq 130 ]]; then
            interrupted
            return ${exit_code}
        else
            local err_sep="$(printf '%*s' "${__animations__term_width}" '' | tr ' ' '-')"
            local lines=10
            __animations::stop "${__animations__animation_pid}"
            __animations::msg "Error ${exit_code}: ${__animations__command_name} failed!" "r"
            __animations::msg "Here are the last ${lines} lines of the log: '${__animations__log_file}'"
            __animations::msg "${err_sep}"
            tail -n ${lines} "${__animations__log_file}" | while read -r line; do
                __animations::msg "> ${line}" "r"
            done
            __animations::msg "${err_sep}"
            return ${exit_code}
        fi
    fi
}

# Lists all available animations in the animations directory.
__animations::list() {
    if [[ -d "${__animations__animations_dir}" ]]; then
        if [[ -z "$(ls -A "${__animations__animations_dir}")" ]]; then
            __animations::msg "No animations found in '${__animations__animations_dir}'."
        else
            __animations::msg "Available animations:"
            for anim in "${__animations__animations_dir}"/*.sh; do
                if [[ -f "${anim}" ]]; then
                    __animations::msg " - $(basename "${anim}" .sh)"
                fi
            done
        fi
    else
        __animations::msg "${__animations__program_name}: Animations directory '${__animations__animations_dir}' not found." "r"
        __animations::msg "Try '${__animations__program_name} --help' for more information."
    fi
}

# Prints usage information for the program.
# Variables:
#   __animations__program_name: Name of the program.
#   __animations__program_version: Version of the program.
__animations::usage() {
    printf "%s\n" "Usage: ${__animations__program_name} [OPTION] [--] COMMAND [ARGS...]"
    printf "%s\n" ""
    printf "%s\n" "${__animations__program_name} is a light-weight BASH script that displays"
    printf "%s\n" "an animation while executing a command."
    printf "%s\n" ""
    printf "%s\n" "Options:"
    printf "%s\n" "  -f, --frames <LIST>          Comma-separated list of strings to use as"
    printf "%s\n" "                               animation frames."
    printf "%s\n" "  -a, --animation <NAME>       Name of the animation to use."
    printf "%s\n" "                               (default: dots)"
    printf "%s\n" "  -i, --interval <SECONDS>     Time interval between frames."
    printf "%s\n" "                               (default: 0.1)"
    printf "%s\n" "  -p, --prefix <STRING>        Prefix text for the animation."
    printf "%s\n" "  -s, --suffix <STRING>        Suffix text for the animation."
    printf "%s\n" ""
    printf "%s\n" "Note:"
    printf "%s\n" "  Use <name> in the prefix and suffix to include the command name."
    printf "%s\n" ""
    printf "%s\n" "  -A, --animations-dir <PATH>  Custom directory for animation files."
    printf "%s\n" "                               (default: HOME/.local/share/animations)"
    printf "%s\n" "  -L, --logs-dir <PATH>        Custom directory for log files."
    printf "%s\n" "                               (default: TMPDIR/animation_logs"
    printf "%s\n" ""
    printf "%s\n" "Note:"
    printf "%s\n" "  All command output will be sent to 'logs-dir/name.log'."
    printf "%s\n" ""
    printf "%s\n" "  -l, --list                   List all available animations."
    printf "%s\n" "  -h, --help                   Print help message and exit."
    printf "%s\n" "  -v, --version                Print version and exit."
    printf "%s\n" ""
    printf "%s\n" "Examples:"
    printf "%s\n" "  $ ${__animations__program_name} -a classic -i 0.1 -p 'Sleeping ' -- sleep 3"
}

# Prints program version.
# Variables:
#   __animations__program_name: Name of the program.
#   __animations__program_version: Version of the program.
__animations::version() {
    local author="Jore <https://github.com/jorexdeveloper>"
    printf "%s\n" "${__animations__program_name} version ${__animations__program_version}"
    printf "%s\n" "Copyright (C) 2025 ${author}."
    printf "%s\n" "License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>."
    printf "%s\n" ""
    printf "%s\n" "This is free software, you are free to change and redistribute it."
    printf "%s\n" "There is NO WARRANTY, to the extent permitted by law."
    printf "%s\n" ""
    printf "%s\n" "Written by ${author}."
}

################################################################################
#                                 ENTRY POINT                                  #
################################################################################
::() {
    # Used for messages
    __animations__program_name="$(basename "${BASH_SOURCE[0]:-${0}}")"
    __animations__program_version="1.0.4"

    # Use for proper output formatting
    __animations__term_width=$(stty size | cut -d' ' -f2)

    __animations__animations_dir="$(realpath "${HOME:-.}/.local/share/animations")" # Default animations directory
    __animations__log_dir="${TMPDIR:-.}/animation_logs"                             # Default logs directory

    # Default animation settings
    __animations__frames=("   " ".  " ".. " "...") # Default frames
    __animations__prefix="Executing <name> "       # Default prefix
    __animations__suffix=""                        # Default suffix
    __animations__interval=0.1                     # Default interval
    __animations__command=()                       # Command to execute
    __animations__animation_name=""                # Animation name

    # Parse command-line options
    __animations::options "${@}"
    local exit_status=${?}
    if [[ "${exit_status}" -eq 5 ]]; then
        return
    elif ! [[ "${exit_status}" -eq 0 ]]; then
        return "${exit_status}"
    fi

    # Load animation if specified
    if [[ -n "${__animations__animation_name}" ]]; then
        __animations::load || return 1
    fi

    # Check if a command is provided
    if [[ ${#__animations__command[@]} -eq 0 ]]; then
        __animations::msg "${__animations__program_name} requires a command to execute." "y"
        __animations::msg "Try '${__animations__program_name} --help' for more information."
        return
    fi

    # Use of array index 1 is fix for zsh
    __animations__command_name=$(basename "${__animations__command[0]:-${__animations__command[1]}}")

    # Format prefix and suffix
    __animations__prefix="${__animations__prefix//<name>/${__animations__command_name}}"
    __animations__suffix="${__animations__suffix//<name>/${__animations__command_name}}"

    # Set log file
    __animations__log_file="${__animations__log_dir}/${__animations__command_name}.log"
    mkdir -p "${__animations__log_dir}" &&
        touch "${__animations__log_file}"

    # Execute command with animation
    __animations::execute "${__animations__command[@]}"
}

################################################################################
#                                 ENTRY POINT                                  #
################################################################################
:: "${@}"
