#!/bin/bash
# Install packages and set up the GNOME desktop. Edit the lists below to taste.
set -euo pipefail

# Basic CLI tools.
ESSENTIALS=(curl wget git ca-certificates tree htop unzip zip)

# Minimal GNOME desktop + login screen.
DESKTOP=(gnome-core gdm3)

# Useful GUI apps.
APPS=(chromium vlc vim-gtk3 gnome-tweaks gnome-shell-extension-manager fonts-jetbrains-mono libnotify-bin)

# GNOME apps to remove (browser replaces these).
REMOVE=(
    gnome-calculator gnome-characters gnome-contacts gnome-maps gnome-weather
    gnome-music gnome-sound-recorder gnome-snapshot gnome-tour gnome-text-editor
    totem simple-scan evince papers
)

export DEBIAN_FRONTEND=noninteractive
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"

echo "==> Updating package lists..."
$SUDO apt-get update -y

echo "==> Installing essentials + desktop + apps..."
$SUDO apt-get install -y "${ESSENTIALS[@]}" "${DESKTOP[@]}" "${APPS[@]}"

# Remove only the extras that are actually installed, so apt won't error.
to_remove=()
for app in "${REMOVE[@]}"; do
    if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "install ok installed"; then
        to_remove+=("$app")
    fi
done
if [ "${#to_remove[@]}" -gt 0 ]; then
    echo "==> Removing: ${to_remove[*]}"
    $SUDO apt-get purge -y "${to_remove[@]}"
    $SUDO apt-get autoremove -y --purge
fi

echo "[ok] Packages done. Reboot to start the desktop."
