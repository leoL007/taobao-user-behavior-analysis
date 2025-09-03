-- 分析1：整体流量指标 (每日PV, UV)
-- PV (Page View): 总浏览量，代表用户“点击”了多少次
-- UV (Unique Visitor): 总独立访客数，代表总共有多少“人”来过
-- ------------------------------------------------------------------

SELECT 
    event_date,
    COUNT(*) AS pv, -- 计算所有行为的总数作为PV
    COUNT(DISTINCT user_id) AS uv -- 计算去重后的用户ID数作为UV
FROM 
    user_behavior
GROUP BY 
    event_date
ORDER BY 
    event_date;

-- 分析2：用户行为转化漏斗
-- 目标：计算有多少用户完成了“浏览”、“加购/收藏”、“购买”这几个关键步骤
-- ------------------------------------------------------------------

-- 使用WITH子句构建一个临时表，分别计算每个环节的独立用户数(UV)
WITH FunnelData AS (
    -- 第1步：计算总的独立访客数
    SELECT '1_total_uv' AS step, COUNT(DISTINCT user_id) AS user_count
    FROM user_behavior

    UNION ALL

    -- 第2步：计算有过“加购”或“收藏”行为的独立用户数
    SELECT '2_cart_or_fav_uv' AS step, COUNT(DISTINCT user_id) AS user_count
    FROM user_behavior
    WHERE behavior_type IN ('cart', 'fav')

    UNION ALL

    -- 第3步：计算有过“购买”行为的独立用户数
    SELECT '3_buy_uv' AS step, COUNT(DISTINCT user_id) AS user_count
    FROM user_behavior
    WHERE behavior_type = 'buy'
)
-- 从临时表中查询最终结果
SELECT 
    step,
    user_count
FROM 
    FunnelData
ORDER BY 
    step;

-- 分析3：热门销量的Top 10商品品类
-- 目标：找出哪些品类的商品被购买的次数最多
-- ------------------------------------------------------------------

SELECT
    category_id,
    COUNT(*) AS purchase_count -- 计算每个品类的购买行为总次数
FROM
    user_behavior
WHERE
    behavior_type = 'buy' -- 只筛选出“购买”行为
GROUP BY
    category_id
ORDER BY
    purchase_count DESC -- 按购买次数从高到低排序
LIMIT 10; -- 只显示前10名
    
    
    
    
    
    
    
    