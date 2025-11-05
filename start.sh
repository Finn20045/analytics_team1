#!/bin/bash

# Запускаем сервер в фоне (официальный образ уже имеет правильную конфигурацию)
echo "Starting ClickHouse server..."
/usr/bin/clickhouse-server --config-file=/etc/clickhouse-server/config.xml &
SERVER_PID=$!

# Ждем запуска
echo "Waiting for ClickHouse to start..."
for i in {1..30}; do
    if clickhouse-client --query "SELECT 1" 2>/dev/null; then
        echo "✅ ClickHouse is ready!"
        break
    fi
    echo "Waiting... attempt $i/30"
    sleep 2
done

# Проверяем, запустился ли ClickHouse
if ! clickhouse-client --query "SELECT 1" 2>/dev/null; then
    echo "❌ ClickHouse failed to start"
    exit 1
fi

# Даем время для выполнения init.sql
echo "Waiting for database initialization..."
sleep 10

# Выполняем запросы для задания
echo ""
echo "=== ClickHouse Lab 1 ==="
clickhouse-client --query "SELECT version() as 'ClickHouse Version'"

echo ""
echo "=== Database Information ==="
clickhouse-client --query "
SELECT 
    'Database name: test_db' as info
UNION ALL
SELECT 
    'Table rows count: ' || toString(count()) as info 
FROM tutorial.hits_v1
UNION ALL
SELECT 
    'Table columns count: ' || toString(count()) as info 
FROM system.columns 
WHERE database = 'tutorial' AND table = 'hits_v1'
"

echo ""
echo "✅ Все запросы выполнены успешно!"
echo "ClickHouse server is running on port 8123"

# Бесконечное ожидание чтобы контейнер не завершался
wait $SERVER_PID