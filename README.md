# Monitoring Task — Тестовое задание

## Описание

Этот проект реализует мониторинг процесса `test` в Linux с помощью bash-скрипта и systemd.
Скрипт делает следующее:

- Проверяет, запущен ли процесс `test`
- Если запущен — делает HTTPS-запрос на `https://test.com/monitoring/test/api` и, если эндпоинт недоступен, пишет в лог `/var/log/monitoring.log`
- Если процесс перезапустился — пишет в лог `/var/log/monitoring.log`

## Файлы

- `script-monitoring` — основной скрипт мониторинга
- `service-monitoring` — systemd-сервис
- `timer-monitoring` — systemd-таймер
- `test` - скрипт запуска процесса "test"
- `setup.sh` - скрипт быстрой настройки окружения (он раскидает все файлы по местам и запустит скрипт и юнит)
- `cleanup.sh` - скрипт отката изменений, сделанных `setup.sh`

## Запуск
1. Скачать репозиторий:
```
git clone git@github.com:yarustina/monitoring.git
```
2. Зайти в директорию:
```
cd monitoring-task
```
3. Запустить установочный скрипт:
```
./setup.sh
```
4. Перезапустить процесс 'test':
```
pgrep -x 'test' | xargs kill ; ./test &
```
5. Посмотреть лог:
```
~/monitoring-task# tail /var/log/monitoring.log
2025-07-30 22:25:41 Monitoring endpoint is unavailable.
2025-07-30 22:25:41 Process 'test' restarted. Old PID: 727385, New PID: 739516
```
