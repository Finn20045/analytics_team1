#!/bin/bash

# Запускаем ClickHouse server в фоне
echo "🔄 Запуск ClickHouse..."
clickhouse-server --config-file=/etc/clickhouse-server/config.xml &
SERVER_PID=$!

# Ждем пока ClickHouse запустится
wait_for_clickhouse() {
    echo "⏳ Ожидание запуска ClickHouse..."
    for i in {1..30}; do
        if clickhouse-client --query "SELECT 1" 2>/dev/null; then
            echo "✅ ClickHouse запущен!"
            return 0
        fi
        sleep 2
    done
    echo "❌ ClickHouse не запустился"
    return 1
}

# Ждем запуска
wait_for_clickhouse

# Даем время для выполнения init.sql
echo "⏳ Загрузка официальных тестовых данных..."
sleep 15

# АВТОМАТИЧЕСКИЙ ВЫВОД ИНФОРМАЦИИ
echo ""
echo "================================================"
echo "    CLICKHOUSE С ОФИЦИАЛЬНЫМИ ТЕСТОВЫМИ ДАННЫМИ"
echo "================================================"
echo ""

# 1. Версия ClickHouse
echo "1. Версия ClickHouse:"
clickhouse-client --query "SELECT version()"

echo ""

# 2. Информация об официальных тестовых данных
echo "2. Информация о тестовых данных:"
clickhouse-client --query "
SELECT 
    'База данных: official_datasets' as info
UNION ALL
SELECT 
    'Таблица: hits (официальная тестовая)' as info
UNION ALL
SELECT 
    'Количество строк в hits: ' || toString(count()) as info 
FROM official_datasets.hits
UNION ALL
SELECT 
    'Количество колонок в hits: ' || toString(count()) as info 
FROM system.columns 
WHERE database = 'official_datasets' AND table = 'hits'
UNION ALL
SELECT 
    'Таблица: visits (официальная тестовая)' as info
UNION ALL
SELECT 
    'Количество строк в visits: ' || toString(count()) as info 
FROM official_datasets.visits
UNION ALL
SELECT 
    'Количество колонок в visits: ' || toString(count()) as info 
FROM system.columns 
WHERE database = 'official_datasets' AND table = 'visits'
"

echo ""
echo "================================================"
echo "✅ Задание 1 выполнено с официальными данными!"
echo "================================================"

# Оставляем сервер работать
wait $SERVER_PID