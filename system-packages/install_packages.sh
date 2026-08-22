#!/bin/bash
# Install preferred packages.
set -euo pipefail

# Packages to install
PACKAGES=(
    curl
    libnotify-bin
    fonts-jetbrains-mono
    tree
    vim-gtk3
    vlc
)

export DEBIAN_FRONTEND=noninteractive

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

echo "==> Updating package lists..."
$SUDO apt-get update -y

echo "==> Installing: ${PACKAGES[*]}"
$SUDO apt-get install -y "${PACKAGES[@]}"

echo "[ok] Packages installed."
