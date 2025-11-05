-- Простая инициализация официальных данных
CREATE DATABASE IF NOT EXISTS official_datasets;

CREATE TABLE official_datasets.hits
(
    WatchID UInt64,
    Title String,
    EventDate Date,
    CounterID UInt32,
    ClientIP UInt32,
    RegionID UInt32
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(EventDate)
ORDER BY (CounterID, EventDate);

INSERT INTO official_datasets.hits VALUES 
(123456789, 'ClickHouse Main Page', '2024-01-15', 1001, 3232235777, 1),
(123456790, 'ClickHouse Documentation', '2024-01-16', 1002, 3232235778, 2),
(123456791, 'ClickHouse Download', '2024-01-17', 1003, 3232235779, 3);