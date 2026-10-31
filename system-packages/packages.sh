#!/bin/bash
# Install packages and set up the GNOME desktop. Edit the lists below to taste.
set -euo pipefail

# Basic CLI tools.
ESSENTIALS=(curl wget git ca-certificates tree unzip zip network-manager)

# Minimal GNOME desktop and login screen.
DESKTOP=(gnome-core gdm3)

# Useful GUI apps.
APPS=(chromium vlc vim-gtk3 gnome-tweaks gnome-shell-extension-manager gnome-shell-extension-gsconnect fonts-jetbrains-mono aria2 libnotify-bin)

# Desktop pieces to protect from autoremove.
KEEP=(gnome-shell gnome-session gnome-control-center gnome-settings-daemon nautilus gnome-terminal gnome-console gdm3 network-manager)

# GNOME apps to remove.
REMOVE=(
    gnome-calculator gnome-characters gnome-contacts gnome-maps gnome-weather
    gnome-music gnome-sound-recorder gnome-snapshot gnome-tour gnome-text-editor
    totem simple-scan evince papers nm-connection-editor
    gnome-connections gnome-font-viewer gnome-calendar gnome-clocks
    gnome-logs malcontent loupe eog ibus
    gnome-disk-utility gnome-system-monitor baobab
    system-config-printer firefox-esr shotwell seahorse file-roller 
    libreoffice-core libreoffice-common libreoffice-writer libreoffice-calc libreoffice-impress
evolution)

export DEBIAN_FRONTEND=noninteractive
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"

echo "==> Updating package lists..."
$SUDO apt-get update -y

echo "==> Installing essentials + desktop + apps..."
$SUDO apt-get install -y "${ESSENTIALS[@]}" "${DESKTOP[@]}" "${APPS[@]}"

# Protect the desktop so purging extras can't cascade into it.
$SUDO apt-mark manual "${KEEP[@]}" 2>/dev/null || true

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


