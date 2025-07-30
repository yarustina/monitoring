#!/bin/bash

LOGFILE="/var/log/monitoring.log"
PROCESS_NAME="test"
API_URL="https://test.com/monitoring/test/api"
STATE_FILE="/var/run/.monitoring_state"

PID=$(pgrep -x "$PROCESS_NAME")

if [[ -n "$PID" ]]; then
    if [[ -f "$STATE_FILE" ]]; then
        OLD_PID=$(cat "$STATE_FILE")
        if [[ "$PID" != "$OLD_PID" ]]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Process '$PROCESS_NAME' restarted. Old PID: $OLD_PID, New PID: $PID" >> "$LOGFILE"
        fi
    fi

    echo "$PID" > "$STATE_FILE"

    if ! curl -s --head --request GET "$API_URL" | grep "200 OK" > /dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Monitoring server unavailable" >> "$LOGFILE"
    fi
fi
