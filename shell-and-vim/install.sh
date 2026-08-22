#!/bin/bash
# Symlink .bash_aliases and .vimrc into the normal user's home AND root's home,
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

SRC_ALIASES="$SCRIPT_DIR/.bash_aliases"
SRC_VIMRC="$SCRIPT_DIR/.vimrc"
MARKER="# linux-setup: load aliases"

# Install both dotfiles into one home directory.
install_to_home() {
    local home="$1" run="${2:-}"

    local f
    for f in .bash_aliases .vimrc; do
        $run bash -c "$(declare -f backup_if_real_file); backup_if_real_file '$home/$f'" 2>/dev/null || true
    done
    $run ln -sfn "$SRC_ALIASES" "$home/.bash_aliases"
    $run ln -sfn "$SRC_VIMRC"   "$home/.vimrc"

    $run touch "$home/.bashrc"
    if $run grep -qE '(\.|source)[[:space:]]+.*\.bash_aliases' "$home/.bashrc" 2>/dev/null \
       || $run grep -qF "$MARKER" "$home/.bashrc" 2>/dev/null; then
        : # already loads aliases, nothing to do
    else
        printf '\n%s\nif [ -f "%s/.bash_aliases" ]; then . "%s/.bash_aliases"; fi\n' \
            "$MARKER" "$home" "$home" | $run tee -a "$home/.bashrc" >/dev/null
    fi

    ok "Dotfiles linked into $home"
}

info "Installing shell & vim dotfiles..."

human="$(real_user)"
human_home="$(real_home)"

if [ "$(id -u)" -ne 0 ]; then
    install_to_home "$human_home" ""        # your home, directly
    install_to_home "/root"       "sudo"    # root's home, via sudo
else
    if [ -n "${SUDO_USER:-}" ]; then
        install_to_home "$human_home" "sudo -u $human"
    else
        warn "No normal user detected; only configuring /root."
    fi
    install_to_home "/root" ""
fi

ok "Shell & vim setup complete. Open a new terminal to see the changes."
