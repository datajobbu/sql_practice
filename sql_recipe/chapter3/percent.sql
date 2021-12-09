-- 값 비율 계산
DROP TABLE IF EXISTS advertising_stats;
CREATE TABLE advertising_stats (
    dt          varchar(255)
  , ad_id       varchar(255)
  , impressions integer
  , clicks      integer
);

INSERT INTO advertising_stats
VALUES
    ('2017-04-01', '001', 100000,  3000)
  , ('2017-04-01', '002', 120000,  1200)
  , ('2017-04-01', '003', 500000, 10000)
  , ('2017-04-02', '001',      0,     0)
  , ('2017-04-02', '002', 130000,  1400)
  , ('2017-04-02', '003', 620000, 15000)
;

/*
-- 정수 자료형 데이터 나누기
*/
SELECT
    dt
    , ad_id
    , clicks / impressions AS ctr
    , 100 * clicks / impressions AS ctr_as_percent
FROM
    advertising_stats
WHERE 
    dt = '2017-04-01'
ORDER BY
    dt, ad_id
;
-- +------------+-------+--------+----------------+
-- | dt         | ad_id | ctr    | ctr_as_percent |
-- +------------+-------+--------+----------------+
-- | 2017-04-01 | 001   | 0.0300 |         3.0000 |
-- | 2017-04-01 | 002   | 0.0100 |         1.0000 |
-- | 2017-04-01 | 003   | 0.0200 |         2.0000 |
-- +------------+-------+--------+----------------+

/*
-- 0 나누기 피하기
-- NULLIF == IFNULL ??? */
SELECT
    dt
    , ad_id
    , CASE
        WHEN impressions > 0 THEN 100 * clicks / impressions
    END AS ctr_as_percent_by_case
    , 100 * clicks / NULLIF(impressions, 0) AS ctr_as_percent_by_null
FROM
    advertising_stats
ORDER BY
    dt, ad_id
;
-- +------------+-------+------------------------+------------------------+
-- | dt         | ad_id | ctr_as_percent_by_case | ctr_as_percent_by_null |
-- +------------+-------+------------------------+------------------------+
-- | 2017-04-01 | 001   |                 3.0000 |                 3.0000 |
-- | 2017-04-01 | 002   |                 1.0000 |                 1.0000 |
-- | 2017-04-01 | 003   |                 2.0000 |                 2.0000 |
-- | 2017-04-02 | 001   |                   NULL |                   NULL |
-- | 2017-04-02 | 002   |                 1.0769 |                 1.0769 |
-- | 2017-04-02 | 003   |                 2.4194 |                 2.4194 |
-- +------------+-------+------------------------+------------------------+