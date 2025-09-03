-- 步骤1：创建一个新的、结构更优的表 user_behavior
-- 我们不直接修改原表，而是创建一个新表，这是更安全规范的做法
CREATE TABLE user_behavior (
    user_id       BIGINT,
    item_id       BIGINT,
    category_id   BIGINT,
    behavior_type VARCHAR(10),
    event_time    DATETIME,  -- 用来存储标准时间
    event_date    DATE       -- 用来存储日期，方便按天分组
);


SELECT * FROM raw_behavior LIMIT 1;


-- 步骤2：将原始数据清洗后插入新表 (最终修正版)
-- ------------------------------------------------------------------
-- 我们使用反引号 `` 来引用这些特殊的数字列名
INSERT INTO user_behavior (user_id, item_id, category_id, behavior_type, event_time, event_date)
SELECT 
    CAST(`1` AS SIGNED),            
    CAST(`2268318` AS SIGNED),
    CAST(`2520377` AS SIGNED),
    `pv`,
    FROM_UNIXTIME(CAST(`1511544070` AS SIGNED)), 
    DATE(FROM_UNIXTIME(CAST(`1511544070` AS SIGNED)))
FROM 
    raw_behavior;


SELECT * FROM user_behavior LIMIT 10;