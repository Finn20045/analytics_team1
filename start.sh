#!/bin/bash

# Запускаем сервер в фоне
echo "Starting ClickHouse server..."
clickhouse-server --config-file=/etc/clickhouse-server/config.xml &
SERVER_PID=$!

# Функция проверки через HTTP (порт 8123)
wait_for_clickhouse() {
    echo "Waiting for ClickHouse to be ready..."
    until curl -s "http://localhost:8123/" > /dev/null; do
        echo "ClickHouse is not ready yet... waiting 3 seconds"
        sleep 3
    done
    echo "ClickHouse is ready!"
}

# Ждем полного запуска
wait_for_clickhouse

# Даем время для выполнения init.sql
echo "Waiting for database initialization..."
sleep 10

# Выполняем запросы для задания
echo "=== ClickHouse Lab 1 ==="
curl -s "http://localhost:8123/?query=SELECT%20version()%20as%20ClickHouseVersion"

echo ""
echo ""
echo "=== Database Information ==="
curl -s "http://localhost:8123/?query=SELECT%20'Database%20name:%20test_db'%20as%20info%20UNION%20ALL%20SELECT%20'Table%20rows%20count:%20'%20%7C%7C%20toString(count())%20as%20info%20FROM%20tutorial.hits_v1%20UNION%20ALL%20SELECT%20'Table%20columns%20count:%20'%20%7C%7C%20toString(count())%20as%20info%20FROM%20system.columns%20WHERE%20database%20%3D%20'tutorial'%20AND%20table%20%3D%20'hits_v1'"

echo ""
echo ""
echo "✅ Все запросы выполнены успешно!"
echo "ClickHouse server is running on port 8123"
echo "Connect with: clickhouse-client"

# Ожидаем завершения
wait $SERVER_PID