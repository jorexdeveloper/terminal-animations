#!/usr/bin/env bash

# Tests the animations in ./animations

[[ -t 1 ]] || exit 1

animations_dir="$(realpath "$(dirname "${0}")/animations")"
cmd="$(realpath "$(dirname "${0}")/tan")"

cd "${animations_dir}" || exit 1
for animation in *.sh; do
    animation="${animation%.sh}"
    clear
    "${cmd}" -A . -a "${animation}" -p "${animation} " -- sleep 5 || exit
done
