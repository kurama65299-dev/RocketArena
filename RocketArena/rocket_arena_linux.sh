#!/bin/sh
printf '\033c\033]0;%s\a' RocketArena
base_path="$(dirname "$(realpath "$0")")"
"$base_path/rocket_arena_linux.x86_64" "$@"
