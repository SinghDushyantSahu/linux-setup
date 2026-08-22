#!/bin/bash
# Update /etc/hosts with the ad/malware blocklist
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

info "Updating /etc/hosts blocklist..."

if ! have python3; then
    err "python3 not found - cannot update hosts file."
    exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
    python3 "$SCRIPT_DIR/update_hosts.py"
else
    sudo python3 "$SCRIPT_DIR/update_hosts.py"
fi

ok "Hosts blocklist updated."
