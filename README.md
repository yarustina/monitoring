# Monitoring Task — Тестовое задание

## Описание

Этот проект реализует мониторинг процесса `test` в Linux с помощью bash-скрипта и systemd.
Скрипт делает следующее:

- Проверяет, запущен ли процесс `test`
- Если запущен — делает HTTPS-запрос на `https://test.com/monitoring/test/api`
- Если процесс перезапустился — пишет в лог `/var/log/monitoring.log`
- Если сервер мониторинга недоступен — тоже пишет в лог

## Файлы

- `monitoring.sh` — основной скрипт мониторинга
- `monitoring.service` — systemd-сервис
- `monitoring.timer` — systemd-таймер

## Установка (если нужно)

```bash
sudo cp monitoring.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/monitoring.sh

sudo cp monitoring.service /etc/systemd/system/
sudo cp monitoring.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now monitoring.timer

## fake-test.sh (если нужно)

Это простой скрипт, который создаёт бесконечный процесс с именем `test`.
Используется для тестирования работы скрипта мониторинга процесса.

Запуск:

```bash
./fake-test.sh &
