-- 세로 기반 데이터를 가로 기반으로 변환하기
DROP TABLE IF EXISTS daily_kpi;
CREATE TABLE daily_kpi (
    dt        varchar(255)
  , indicator varchar(255)
  , val       integer
);

INSERT INTO daily_kpi
VALUES
    ('2017-01-01', 'impressions', 1800)
  , ('2017-01-01', 'sessions'   ,  500)
  , ('2017-01-01', 'users'      ,  200)
  , ('2017-01-02', 'impressions', 2000)
  , ('2017-01-02', 'sessions'   ,  700)
  , ('2017-01-02', 'users'      ,  250)
;

/*
-- Row To Column By MAX, CASE
*/
SELECT
    dt
    , MAX(CASE WHEN indicator = "impressions" THEN val END) AS impressions
    , MAX(CASE WHEN indicator = "sessions" THEN val END) AS sessions
    , MAX(CASE WHEN indicator = "users" THEN val END) AS users
FROM
    daily_kpi
GROUP By
    dt
ORDER BY
    dt
;
-- +------------+-------------+----------+-------+
-- | dt         | impressions | sessions | users |
-- +------------+-------------+----------+-------+
-- | 2017-01-01 |        1800 |      500 |   200 |
-- | 2017-01-02 |        2000 |      700 |   250 |
-- +------------+-------------+----------+-------+