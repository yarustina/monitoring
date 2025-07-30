#!/bin/bash

PROCESS_NAME="test"
STATE_FILE="/tmp/${PROCESS_NAME}_pid.state"
LOGFILE="/var/log/monitoring.log"
API_URL="https://test.com/monitoring/test/api"

echo "$(date '+%Y-%m-%d %H:%M:%S') Script started" >> "$LOGFILE"

PID=$(pgrep -x "$PROCESS_NAME")

if [[ -z "$PID" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') Process '$PROCESS_NAME' not running." >> "$LOGFILE"
    exit 0
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') Found process '$PROCESS_NAME' with PID $PID" >> "$LOGFILE"

if [[ -f "$STATE_FILE" ]]; then
    OLD_PID=$(cat "$STATE_FILE")
    if [[ "$PID" != "$OLD_PID" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Process '$PROCESS_NAME' restarted. Old PID: $OLD_PID, New PID: $PID" >> "$LOGFILE"
    fi
fi

echo "$PID" > "$STATE_FILE"

if ! curl -s --head --request GET "$API_URL" | grep "200 OK" > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') Monitoring server unavailable." >> "$LOGFILE"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') Monitoring server is available." >> "$LOGFILE"
fi
