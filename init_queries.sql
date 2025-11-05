-- Создание базы данных для лабораторной работы
CREATE DATABASE IF NOT EXISTS lab_work;

USE lab_work;

-- Создание таблицы с продажами
CREATE TABLE IF NOT EXISTS sales (
    id UInt32,
    product_name String,
    category String,
    price Decimal(10,2),
    quantity UInt32,
    sale_date Date,
    customer_id UInt32,
    region String
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(sale_date)
ORDER BY (sale_date, id);

-- Вставка тестовых данных
INSERT INTO sales VALUES
(1, 'Laptop', 'Electronics', 999.99, 1, '2024-01-15', 1001, 'North'),
(2, 'Mouse', 'Electronics', 25.50, 2, '2024-01-15', 1002, 'South'),
(3, 'Keyboard', 'Electronics', 75.00, 1, '2024-01-16', 1003, 'East'),
(4, 'Monitor', 'Electronics', 299.99, 1, '2024-01-17', 1001, 'North'),
(5, 'Desk', 'Furniture', 199.99, 1, '2024-01-17', 1004, 'West'),
(6, 'Chair', 'Furniture', 149.99, 4, '2024-01-18', 1005, 'South'),
(7, 'Tablet', 'Electronics', 399.99, 2, '2024-01-19', 1006, 'East'),
(8, 'Phone', 'Electronics', 699.99, 1, '2024-01-20', 1007, 'North');

-- Базовые запросы для демонстрации навыков

-- 1. Выбор всех данных
SELECT '1. Все данные из таблицы sales:' as query_name;
SELECT * FROM sales;

-- 2. Агрегатные функции
SELECT '2. Статистика по продажам:' as query_name;
SELECT 
    count() as total_sales,
    sum(price * quantity) as total_revenue,
    avg(price) as avg_price,
    min(price) as min_price,
    max(price) as max_price
FROM sales;

-- 3. Группировка по категориям
SELECT '3. Продажи по категориям:' as query_name;
SELECT 
    category,
    count() as sales_count,
    sum(price * quantity) as total_revenue,
    avg(price) as avg_price
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- 4. Группировка по регионам
SELECT '4. Продажи по регионам:' as query_name;
SELECT 
    region,
    count() as sales_count,
    sum(price * quantity) as total_revenue
FROM sales
GROUP BY region
ORDER BY total_revenue DESC;

-- 5. Фильтрация данных
SELECT '5. Продажи дороже 500:' as query_name;
SELECT * FROM sales WHERE price > 500;

-- 6. Продажи по датам
SELECT '6. Продажи по дням:' as query_name;
SELECT 
    sale_date,
    count() as daily_sales,
    sum(price * quantity) as daily_revenue
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

-- 7. Топ клиентов по объему покупок
SELECT '7. Топ клиентов:' as query_name;
SELECT 
    customer_id,
    count() as purchase_count,
    sum(price * quantity) as total_spent
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 8. Подсчет общего количества строк и столбцов
SELECT '8. Информация о таблице:' as query_name;
SELECT 
    'Total rows: ' || toString(count()) as table_info
FROM sales
UNION ALL
SELECT 
    'Total columns: ' || toString(count()) as table_info
FROM system.columns 
WHERE database = 'lab_work' AND table = 'sales';