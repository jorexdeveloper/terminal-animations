#!/bin/bash

################################################################################
#                                                                              #
#    terminal-animations 2025-1.0                                              #
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
# shellcheck disable=SC2155 disable=SC1090

################################################################################
#                                FUNCTIONS                                     #
################################################################################

# Prints a message with optional coloring.
# Arguments:
#   1. Message to print.
#   2. Color code (r: red, g: green, y: yellow, b: blue, c: cyan). Default: none.
msg() {
    local color
    case "${2}" in
        r) color="\033[1;31m" ;;
        g) color="\033[1;32m" ;;
        y) color="\033[1;33m" ;;
        b) color="\033[1;34m" ;;
        c) color="\033[1;36m" ;;
        *) color="\033[0m" ;;
    esac
    printf "%b%-${term_width}s%b\n" "${color}" "${1}" "\033[0m"
}

# Lists all available animations in the animations directory.
list_animations() {
    if [[ -d "${animations_dir}" ]]; then
        msg "Available animations:"
        for anim in "${animations_dir}"/*.sh; do
            [[ -f "${anim}" ]] && msg " - $(basename "${anim}" .sh)"
        done
    else
        msg "Error: Animations directory '${animations_dir}' not found." "r"
    fi
}

# Parses command-line options and sets animation and command variables.
# Arguments:
#   Command-line options
#   Remaining arguments are the command to execute.
# Sets:
#   frames, prefix, suffix, interval, animation_name, command, log_dir, animations_dir.
parse_options() {
    while getopts ":f:p:i:s:a:hlL:A:" opt; do
        case "${opt}" in
            f)
                IFS=',' read -r -a frames <<<"${OPTARG}"
                ;;
            p)
                prefix="${OPTARG}"
                ;;
            i)
                if [[ ! "${OPTARG}" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                    msg "Error: Interval must be a positive number." "r"
                    print_usage
                    exit 1
                fi
                interval="${OPTARG}"
                ;;
            s)
                suffix="${OPTARG}"
                ;;
            a)
                animation_name="${OPTARG}"
                ;;
            h)
                print_usage
                exit
                ;;
            l)
                list_animations
                exit
                ;;
            L)
                log_dir="$(realpath "${OPTARG}")"
                ;;
            A)
                animations_dir="$(realpath "${OPTARG}")"
                ;;
            \?)
                msg "Error: Invalid option '-${OPTARG}'" "r"
                print_usage
                exit 1
                ;;
            :)
                msg "Error: Option '-${OPTARG}' requires an argument" "r"
                print_usage
                exit 1
                ;;
        esac
    done
    shift $((OPTIND - 1))
    command=("${@}")
}

# Loads the specified animation script.
# Variables:
#   animation_name: Name of the animation to load.
#   animations_dir: Directory containing animation scripts.
load_animation() {
    local animation_file="${animations_dir}/${animation_name}.sh"
    if [[ -f "${animation_file}" ]]; then
        source "${animation_file}"
    else
        msg "Error: Animation '${animation_name}' not found in '${animations_dir}' directory." "r"
        exit 1
    fi
}

# Starts a background animation.
# Variables:
#   frames: Array of animation frames.
#   prefix: Text before the animation.
#   suffix: Text after the animation.
#   interval: Time interval between frames.
# Sets:
#   anim_pid: PID of the animation process.
start_animation() {
    # Display the animation
    animate() {
        local frame
        trap 'printf "\r"' EXIT
        while true; do
            for frame in "${frames[@]}"; do
                printf "\r%-${term_width}s" "${prefix}${frame}${suffix}"
                sleep "${interval}"
            done
        done
    }

    stty -echo         # Hide input
    printf "\033[?25l" # Hide cursor
    animate &          # Run animation in the background
    anim_pid=${!}      # Capture the PID of the animation process
}

# Stops the background animation and restores terminal settings.
# Arguments:
#   1. Animation PID to stop.
stop_animation() {
    local pid=${1}
    if [[ -n "${pid}" ]]; then
        kill "${pid}" &>/dev/null
        wait "${pid}" 2>/dev/null
        printf "\033[?25h" # Restore cursor
        stty echo          # Restore input
    fi
}

# Executes the specified command and logs its output.
# Variables:
#   command: Array containing the command and its arguments.
#   log_file: Path to the log file.
#   anim_pid: PID of the running animation process.
execute_command() {
    local log_sep="$(printf '%*s' "25" '' | tr ' ' '=')"
    {
        echo -e "\n"
        echo "${log_sep}"
        echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Command: ${command_name}"
        echo -n "Arguments: "
        if [[ ${#command[@]} -gt 1 ]]; then
            echo "${command[@]:1}"
        else
            echo "none"
        fi
        echo "Animation: ${animation_name:-default}"
        echo "${log_sep}"
    } >>"${log_file}"
    # Make sure to append to the log file
    if "${command[@]}" &>>"${log_file}"; then
        return # No messages before stop_animation
    else
        local err_sep="$(printf '%*s' "${term_width}" '' | tr ' ' '-')"
        local exit_code=${?}
        local lines=10
        stop_animation "${anim_pid}"
        msg "Error ${exit_code}: ${command_name} failed!" "r"
        msg "Here are the last ${lines} lines of the log: '${log_file}'"
        msg "${err_sep}"
        tail -n ${lines} "${log_file}" | while read -r line; do
            msg "> ${line}" "r"
        done
        msg "${err_sep}"
        exit ${exit_code}
    fi
}

# Prints usage information for the script.
# Variables:
#   script_name: Name of the script.
print_usage() {
    local script_name="$(basename "${0}")"
    msg "Usage: ${script_name} [options] <command>"
    msg ""
    msg "Executes the specified command while displaying a loading animation."
    msg ""
    msg "Options:"
    msg "  -f <frames>      Comma-separated list of animation frames."
    msg "  -p <prefix>      Prefix text for the animation. Use <name> to include the command name."
    msg "  -s <suffix>      Suffix text for the animation. Use <name> to include the command name."
    msg "  -i <seconds>     Time interval between frames. (default: 0.2)"
    msg "  -a <name>        Name of the animation to use. (default: dots)"
    msg "  -l               List all available animations."
    msg "  -h               Display this help message."
    msg "  -L <path>        Custom directory for storing log files."
    msg "  -A <path>        Custom directory for animation scripts."
    msg ""
    msg "Example:"
    msg "  ${script_name} -a dots -p 'Running <name> ' -i 0.5 sleep 5"
    msg ""
    msg "All command output will be sent to '<logs-dir>/<command-name>.log'."
}

################################################################################
#                                 ENTRY POINT                                  #
################################################################################

# Check if the script is being run in a terminal
if [[ ! -t 0 || ! -t 1 ]]; then
    msg "Error: This script must be run in a terminal." "r"
    exit 1
fi

# Use for proper output formatting
term_width=$(stty size | cut -d' ' -f2)

script_dir="$(dirname "${0}")"                          # Script directory
animations_dir="$(realpath "${script_dir}/animations")" # Default animations directory
log_dir="$(realpath "${script_dir}/logs")"              # Default logs directory

# Default animation settings
frames=(".  " ".. " "..." "   ") # Default frames
prefix="Executing <name> "       # Default prefix
suffix=""                        # Default suffix
interval=0.2                     # Default interval
command=()                       # Command to execute
animation_name=""                # Animation name

# Parse command-line options
parse_options "${@}"
mkdir -p "${log_dir}" "${animations_dir}"

# Load animation if specified
if [[ -n "${animation_name}" ]]; then
    load_animation
fi

# Check if a command is provided
if [[ ${#command[@]} -eq 0 ]]; then
    print_usage
    exit
fi

command_name=$(basename "${command[0]}")

prefix="${prefix//<name>/${command_name}}" # Format prefix
suffix="${suffix//<name>/${command_name}}" # Format suffix

log_file="${log_dir}/${command_name}.log"
touch "${log_file}"

start_animation && trap 'stop_animation ${anim_pid}; msg "${command_name} interrupted by user." "y"; exit 130' SIGINT
execute_command
stop_animation "${anim_pid}" && trap - SIGINT
msg "${command_name} is done." "g"
