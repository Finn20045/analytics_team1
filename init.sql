-- Создание базы данных
CREATE DATABASE IF NOT EXISTS test_db;

-- Использование базы данных
USE test_db;

-- Создание таблицы с данными из официального датасета ClickHouse
CREATE TABLE IF NOT EXISTS tutorial.hits_v1
(
    WatchID UInt64,
    JavaEnable UInt8,
    Title String,
    GoodEvent Int16,
    EventTime DateTime,
    EventDate Date,
    CounterID UInt32,
    ClientIP UInt32,
    RegionID UInt32,
    UserID UInt64,
    CounterClass Int8,
    OS UInt8,
    UserAgent UInt8,
    URL String,
    Referer String,
    Refresh UInt8,
    RefererCategoryID UInt16,
    RefererRegionID UInt32,
    URLCategoryID UInt16,
    URLRegionID UInt32,
    ResolutionWidth UInt16,
    ResolutionHeight UInt16,
    ResolutionDepth UInt8,
    FlashMajor UInt8,
    FlashMinor UInt8,
    FlashMinor2 String,
    NetMajor UInt8,
    NetMinor UInt8,
    UserAgentMajor UInt16,
    UserAgentMinor FixedString(2),
    CookieEnable UInt8,
    JavascriptEnable UInt8,
    IsMobile UInt8,
    MobilePhone UInt8,
    MobilePhoneModel String,
    Params String,
    IPNetworkID UInt32,
    TraficSourceID Int8,
    SearchEngineID UInt16,
    SearchPhrase String,
    AdvEngineID UInt8,
    IsArtifical UInt8,
    WindowClientWidth UInt16,
    WindowClientHeight UInt16,
    ClientTimeZone Int16,
    ClientEventTime DateTime,
    SilverlightVersion1 UInt8,
    SilverlightVersion2 UInt8,
    SilverlightVersion3 UInt32,
    SilverlightVersion4 UInt16,
    PageCharset String,
    CodeVersion UInt32,
    IsLink UInt8,
    IsDownload UInt8,
    IsNotBounce UInt8,
    FUniqID UInt64,
    OriginalURL String,
    HID UInt32,
    IsOldCounter UInt8,
    IsEvent UInt8,
    IsParameter UInt8,
    DontCountHits UInt8,
    WithHash UInt8,
    HitColor FixedString(1),
    LocalEventTime DateTime,
    Age UInt8,
    Sex UInt8,
    Income UInt8,
    Interests UInt16,
    Robotness UInt8,
    RemoteIP UInt32,
    WindowName Int32,
    OpenerName Int32,
    HistoryLength Int16,
    BrowserLanguage FixedString(2),
    BrowserCountry FixedString(2),
    SocialNetwork String,
    SocialAction String,
    HTTPError UInt16,
    SendTiming Int32,
    DNSTiming Int32,
    ConnectTiming Int32,
    ResponseStartTiming Int32,
    ResponseEndTiming Int32,
    FetchTiming Int32,
    SocialSourceNetworkID UInt8,
    SocialSourcePage String,
    ParamPrice Int64,
    ParamOrderID String,
    ParamCurrency FixedString(3),
    ParamCurrencyID UInt16,
    OpenstatServiceName String,
    OpenstatCampaignID String,
    OpenstatAdID String,
    OpenstatSourceID String,
    UTMSource String,
    UTMMedium String,
    UTMCampaign String,
    UTMContent String,
    UTMTerm String,
    FromTag String,
    HasGCLID UInt8,
    RefererHash UInt64,
    URLHash UInt64,
    CLID UInt32
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(EventDate)
ORDER BY (CounterID, EventDate, intHash32(UserID))
SAMPLE BY intHash32(UserID);

-- Вставка тестовых данных
INSERT INTO tutorial.hits_v1 VALUES 
(1, 1, 'Test Title', 1, now(), today(), 123, 2130706433, 1, 456, 1, 1, 1, 'http://example.com', 'http://google.com', 0, 1, 1, 1, 1, 1920, 1080, 24, 1, 1, '', 1, 1, 1, '1', 1, 1, 0, 0, '', 'params', 1, 1, 1, 'search', 0, 0, 1920, 1080, 0, now(), 0, 0, 0, 0, 'UTF-8', 1, 0, 0, 1, 789, 'http://example.com', 1, 0, 0, 0, 0, 0, 'R', now(), 25, 1, 3, 123, 0, 2130706433, 0, 0, 5, 'en', 'US', 'facebook', 'like', 200, 100, 10, 20, 30, 40, 50, 1, 'page', 100, 'order123', 'USD', 840, 'service', 'campaign', 'ad', 'source', 'google', 'cpc', 'campaign', 'content', 'term', 'tag', 0, 123456, 654321, 789);

-- Скрипт для вывода информации
SELECT 
    'ClickHouse version: ' || version() as info
UNION ALL
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
WHERE database = 'tutorial' AND table = 'hits_v1';