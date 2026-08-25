#!/bin/bash
# helper functions for all the setup scripts.
# This file is meant to be sourced, not direct run.

# Coloring of responses.
if [ -t 1 ]; then
    _C_RESET=$'\e[0m'; _C_BLUE=$'\e[94m'; _C_GREEN=$'\e[32m'
    _C_YELLOW=$'\e[33m'; _C_RED=$'\e[31m'
else
    _C_RESET=""; _C_BLUE=""; _C_GREEN=""; _C_YELLOW=""; _C_RED=""
fi

info() { printf '%s==>%s %s\n' "$_C_BLUE"   "$_C_RESET" "$*"; }
ok()   { printf '%s[ok]%s %s\n' "$_C_GREEN"  "$_C_RESET" "$*"; }
warn() { printf '%s[!]%s %s\n'  "$_C_YELLOW" "$_C_RESET" "$*" >&2; }
err()  { printf '%s[x]%s %s\n'  "$_C_RED"    "$_C_RESET" "$*" >&2; }

# Yes/No prompts
ask_yn() {
    local prompt="$1" default="${2:-n}" reply hint
    if [ "$default" = "y" ]; then hint="[Y/n]"; else hint="[y/N]"; fi

    if [ ! -t 0 ]; then
        [ "$default" = "y" ] && return 0 || return 1
    fi

    read -r -p "$prompt $hint " reply || reply=""
    reply="${reply:-$default}"
    case "$reply" in
        [Yy]*) return 0 ;;
        *)     return 1 ;;
    esac
}

have() { command -v "$1" >/dev/null 2>&1; }   # is a command available?

# Non-root user and home identifier.
real_user() {
    if [ -n "${SUDO_USER:-}" ]; then echo "$SUDO_USER"; else echo "${USER:-$(id -un)}"; fi
}

real_home() {
    if [ -n "${SUDO_USER:-}" ]; then
        getent passwd "$SUDO_USER" | cut -d: -f6
    else
        echo "$HOME"
    fi
}

# To back up a file if it exists and not a symlink.
backup_if_real_file() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup
        backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
        cp -a "$target" "$backup"
        warn "Backed up existing $target -> $backup"
    fi
}

