#!/bin/bash
# For battery longevity, sends desktop notification when battery level reaches upper limit. Runs forever as systemd --user service.

# Upper limit in percent
LIMIT="${LIMIT:-80}"
# Interval in seconds to recheck battery level
INTERVAL="${INTERVAL:-60}"

# Skip on machines without a battery.
BATTERY_PATH="${BATTERY_PATH:-$(find /sys/class/power_supply/ -maxdepth 1 -name 'BAT*' 2>/dev/null | head -n 1)}"
if [ -z "$BATTERY_PATH" ]; then
    echo "No battery found (desktop machine?). Nothing to do."
    exit 0
fi

# Only notify once per charging session.
ALREADY_NOTIFIED=false

while true; do
    # Read battery status defensively, as battery file can briefly disappear.
    STATUS="$(cat "$BATTERY_PATH/status" 2>/dev/null || echo Unknown)"
    CAPACITY="$(cat "$BATTERY_PATH/capacity" 2>/dev/null || echo -1)"

    if [ "$STATUS" = "Charging" ]; then
        if [ "$CAPACITY" -ge "$LIMIT" ] && [ "$ALREADY_NOTIFIED" = false ]; then
            notify-send "Battery Limit Reached" \
                "Battery is at ${CAPACITY}%. Please unplug the charger." \
                -a "Power" --icon=battery-full --urgency=critical 2>/dev/null || true
            ALREADY_NOTIFIED=true
        fi
    else
        # If not charging, reset the flag.
        ALREADY_NOTIFIED=false
    fi

    sleep "$INTERVAL"
done
