#!/bin/bash
set -euo pipefail

echo ""
echo "   === Откат изменений ==="
systemctl disable --now monitoring.timer 1>/dev/null 2>&1 || true
rm -f /etc/systemd/system/monitoring.service 1>/dev/null 2>&1
rm -f /etc/systemd/system/monitoring.timer 1>/dev/null 2>&1
systemctl daemon-reexec 1>/dev/null 2>&1
systemctl daemon-reload 1>/dev/null 2>&1
rm -f /usr/local/bin/monitoring.sh 1>/dev/null 2>&1
> /var/log/monitoring.log
rm -f /tmp/test_pid.state  1>/dev/null 2>&1
PIDS=$(pgrep -x test || true)
if [[ -n "$PIDS" ]]; then
    kill $PIDS
  echo "   === Процесс 'test' убит ==="
else
  echo "   === Процесс 'test' уже мёртв ==="
fi

echo "   === Откат завершён ==="
echo ""
