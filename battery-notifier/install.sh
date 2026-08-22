#!/bin/bash
# Install the battery notifier as a per-user systemd service.
# Run this as your normal user
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

if [ "$(id -u)" -eq 0 ]; then
    err "Run this as your normal user, not root (systemd --user won't work as root)."
    exit 1
fi

info "Installing battery notifier..."

# Skip on machines without a battery (BATTERY_PATH can override detection)
BATTERY_PATH="${BATTERY_PATH:-$(find /sys/class/power_supply/ -maxdepth 1 -name 'BAT*' 2>/dev/null | head -n 1)}"
if [ -z "$BATTERY_PATH" ]; then
    warn "No battery detected - skipping battery notifier."
    exit 0
fi

if ! have systemctl; then
    warn "systemctl not found - skipping battery notifier."
    exit 0
fi

SERVICE_SRC="$SCRIPT_DIR/battery-ul-notifier.service"
SCRIPT_PATH="$SCRIPT_DIR/battery-ul-notifier.sh"
UNIT_DIR="$HOME/.config/systemd/user"
UNIT_DEST="$UNIT_DIR/battery-ul-notifier.service"

chmod +x "$SCRIPT_PATH" 2>/dev/null || true
mkdir -p "$UNIT_DIR"

sed "s|__EXEC_PATH__|$SCRIPT_PATH|g" "$SERVICE_SRC" > "$UNIT_DEST"

systemctl --user daemon-reload
systemctl --user enable --now battery-ul-notifier.service
systemctl --user restart battery-ul-notifier.service

ok "Battery notifier installed and running."
