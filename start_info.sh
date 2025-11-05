#!/bin/bash

# Запускаем ClickHouse server в фоне
echo "🔄 Запуск ClickHouse..."
clickhouse-server --config-file=/etc/clickhouse-server/config.xml &
SERVER_PID=$!

# Функция проверки через HTTP (более надежно)
wait_for_clickhouse() {
    echo "⏳ Ожидание запуска ClickHouse..."
    local max_attempts=60
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        # Проверяем через HTTP порт 8123
        if curl -s "http://localhost:8123/ping" 2>/dev/null | grep -q "Ok"; then
            echo "✅ ClickHouse запущен после $attempt попыток!"
            return 0
        fi
        
        # Или проверяем через native клиент
        if clickhouse-client --query "SELECT 1" 2>/dev/null; then
            echo "✅ ClickHouse запущен после $attempt попыток!"
            return 0
        fi
        
        echo "Попытка $attempt/$max_attempts..."
        sleep 5
        ((attempt++))
    done
    
    echo "❌ ClickHouse не запустился после $max_attempts попыток"
    return 1
}

# Ждем запуска
if wait_for_clickhouse; then
    # Даем время для выполнения init.sql
    echo "⏳ Загрузка официальных тестовых данных..."
    sleep 10

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
else
    echo "❌ Не удалось запустить ClickHouse"
    exit 1
fi

# Оставляем сервер работать
echo "🔄 ClickHouse продолжает работать..."
wait $SERVER_PID