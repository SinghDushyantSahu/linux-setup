#!/bin/bash
# Remove default GNOME apps you don't want.
set -euo pipefail

# Apps to remove
APPS=(
    gnome-music gnome-weather gnome-maps gnome-contacts gnome-connections
    totem gnome-sound-recorder shotwell gnome-tour gnome-user-docs evolution
    gnome-snapshot gnome-text-editor simple-scan eog loupe evince file-roller
    seahorse gnome-characters malcontent gnome-disk-utility
)

export DEBIAN_FRONTEND=noninteractive

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

# Only try to purge apps that are actually installed
to_remove=()
for app in "${APPS[@]}"; do
    if dpkg-query -W -f='${Status}' "$app" 2>/dev/null | grep -q "install ok installed"; then
        to_remove+=("$app")
    fi
done

if [ "${#to_remove[@]}" -eq 0 ]; then
    echo "[ok] None of the listed GNOME apps are installed; nothing to remove."
    exit 0
fi

echo "==> Removing: ${to_remove[*]}"
$SUDO apt-get purge -y "${to_remove[@]}"
$SUDO apt-get autoremove -y --purge

echo "[ok] GNOME cleanup done."
