#!/bin/bash

set -euo pipefail

trap 'echo ""; echo "❌ Что-то пошло не так. Установка прервана." >&2' ERR

echo ""

echo "   === Запуск процесса test  ==="
chmod +x test
./test &

echo "   === Установка monitoring.sh  ==="
chmod +x script-monitoring
cp script-monitoring /usr/local/bin/monitoring.sh 1>/dev/null 2>&1
chmod +x /usr/local/bin/monitoring.sh 1>/dev/null 2>&1
cp service-monitoring /etc/systemd/system/monitoring.service 1>/dev/null 2>&1
cp timer-monitoring /etc/systemd/system/monitoring.timer 1>/dev/null 2>&1
sleep 1
systemctl daemon-reload 1>/dev/null 2>&1
systemctl enable --now monitoring.timer 1>/dev/null 2>&1
systemctl start monitoring.service 1>/dev/null 2>&1

sleep 3

echo "   === Установка завершена  ==="
echo ""

echo " - Скрипт мониторинга добавлен:"
ls -l /usr/local/bin/monitoring.sh
echo ""

echo " - Проверка сервиса:"
echo "_________________________________________________________________________________________________"
echo ""
# Не используем 'systemctl status monitoring', т.к. сервис в моменты простоя считается мёртвым, а значит возвращает != 0
journalctl -u monitoring.service | tail -3
echo "_________________________________________________________________________________________________"
echo ""

echo " - Проверка таймера:"
echo "_________________________________________________________________________________________________"
echo ""
systemctl status monitoring.timer
echo "_________________________________________________________________________________________________"
echo ""

echo " - Запущен процесс test:"
pgrep -a test
echo ""

echo " - Проверка работы monitoring.sh и логирования:"
tail /var/log/monitoring.log
echo ""
