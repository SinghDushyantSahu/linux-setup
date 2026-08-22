#!/bin/bash
# One script to set up a fresh Debian machine.
# Run it as your NORMAL user (it will ask for your sudo password when needed):

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$REPO_DIR/lib/common.sh"

if [ "$(id -u)" -eq 0 ]; then
    err "Please run setup.sh as your normal user, not with sudo."
    err "It will ask for your password when a step actually needs root."
    exit 1
fi

info "Linux setup - press y/n for each part."
echo

if have sudo; then
    sudo -v || { err "sudo is required for some steps."; exit 1; }
fi

# 1. Packages
if ask_yn "Install preferred packages (curl, vim-gtk3, vlc, ...)?" y; then
    bash "$REPO_DIR/system-packages/install_packages.sh"
fi
echo

# 2. GNOME cleanup
if ask_yn "Remove default GNOME apps (music, maps, evolution, ...)?" n; then
    bash "$REPO_DIR/system-packages/gnome_cleanup.sh"
fi
echo

# 3. Shell & vim dotfiles
if ask_yn "Set up shell prompt and vim config?" y; then
    bash "$REPO_DIR/shell-and-vim/install.sh"
fi
echo

# 4. Battery notifier
if ask_yn "Set up the battery limit notifier service?" y; then
    bash "$REPO_DIR/battery-notifier/install.sh"
fi
echo

# 5. Hosts blocker
if ask_yn "Update /etc/hosts with the ad/malware blocklist?" n; then
    bash "$REPO_DIR/hosts-blocker/install.sh"
fi
echo

ok "All done"
