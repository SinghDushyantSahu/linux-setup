#!/bin/bash
# Set up a fresh Debian machine. Run as ./setup.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$REPO_DIR/lib/common.sh"

# Run only as non root user (root breaks systemd --user and home symlinks).
if [ "$(id -u)" -eq 0 ]; then
    err "Run setup.sh as your normal user, not with sudo."
    exit 1
fi

info "Linux setup - press y/n for each part."
echo

# Ask for the sudo password once, up front.
if have sudo; then
    sudo -v || { err "sudo is required."; exit 1; }
fi

if ask_yn "Install packages & GNOME desktop?" y; then
    bash "$REPO_DIR/system-packages/packages.sh"
fi
echo

if ask_yn "Set up shell prompt and vim config?" y; then
    bash "$REPO_DIR/shell-and-vim/install.sh"
fi
echo

if ask_yn "Set up the battery notifier?" y; then
    bash "$REPO_DIR/battery-notifier/install.sh"
fi
echo

if ask_yn "Update /etc/hosts ad/malware blocklist?" n; then
    bash "$REPO_DIR/hosts-blocker/install.sh"
fi
echo

ok "All done. Reboot to start the desktop."
