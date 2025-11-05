#!/bin/bash

# Запускаем сервер в фоне
echo "Starting ClickHouse server..."
clickhouse-server --config-file=/etc/clickhouse-server/config.xml &
SERVER_PID=$!

# Ждем запуска
echo "Waiting for ClickHouse to start..."
sleep 15

# Выполняем запросы для задания
echo "=== ClickHouse Lab 1 ==="
clickhouse-client --query "SELECT version() as \"ClickHouse Version\""

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
echo "ClickHouse server is running..."
echo "Connect with: docker exec -it <container_id> clickhouse-client"

# Ожидаем завершения
wait $SERVER_PID