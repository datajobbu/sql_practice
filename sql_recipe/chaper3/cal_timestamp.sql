-- 날짜/시간 계산
DROP TABLE IF EXISTS mst_users_with_dates;
CREATE TABLE mst_users_with_dates (
    user_id        varchar(255)
  , register_stamp varchar(255)
  , birth_date     varchar(255)
);

INSERT INTO mst_users_with_dates
VALUES
    ('U001', '2016-02-28 10:00:00', '2000-02-29')
  , ('U002', '2016-02-29 10:00:00', '2000-02-29')
  , ('U003', '2016-03-01 10:00:00', '2000-02-29')
;

/*
-- 날찌/시간 계산
*/
SELECT
    user_id
    , TIMESTAMP(register_stamp) AS register_stamp
    , DATE_ADD(TIMESTAMP(register_stamp), INTERVAL 1 HOUR) AS after_1_hour
    , DATE_SUB(TIMESTAMP(register_stamp), INTERVAL 30 MINUTE) AS before_30_minutes
    
    , DATE(register_stamp) AS register_date
    , DATE(DATE_ADD(DATE(register_stamp), INTERVAL 1 DAY)) AS after_1_day
    , DATE(DATE_SUB(DATE(register_stamp), INTERVAL 1 MONTH)) AS before_1_month
FROM 
    mst_users_with_dates
;
-- +---------+----------------------------+----------------------------+----------------------------+---------------+-------------+----------------+
-- | user_id | register_stamp             | after_1_hour               | before_30_minutes          | register_date | after_1_day | before_1_month |
-- +---------+----------------------------+----------------------------+----------------------------+---------------+-------------+----------------+
-- | U001    | 2016-02-28 10:00:00.000000 | 2016-02-28 11:00:00.000000 | 2016-02-28 09:30:00.000000 | 2016-02-28    | 2016-02-29  | 2016-01-28     |
-- | U002    | 2016-02-29 10:00:00.000000 | 2016-02-29 11:00:00.000000 | 2016-02-29 09:30:00.000000 | 2016-02-29    | 2016-03-01  | 2016-01-29     |
-- | U003    | 2016-03-01 10:00:00.000000 | 2016-03-01 11:00:00.000000 | 2016-03-01 09:30:00.000000 | 2016-03-01    | 2016-03-02  | 2016-02-01     |
-- +---------+----------------------------+----------------------------+----------------------------+---------------+-------------+----------------+

/*
-- 날짜 차이 계산
*/
SELECT
    user_id
    , CURRENT_DATE AS today
    , DATE(register_stamp) AS register_date
    , CURRENT_DATE - DATE(register_stamp) AS diff_days
FROM
    mst_users_with_dates
;
-- +---------+------------+---------------+-----------+
-- | user_id | today      | register_date | diff_days |
-- +---------+------------+---------------+-----------+
-- | U001    | 2021-11-23 | 2016-02-28    |     50895 |
-- | U002    | 2021-11-23 | 2016-02-29    |     50894 |
-- | U003    | 2021-11-23 | 2016-03-01    |     50822 |
-- +---------+------------+---------------+-----------+

/* 나이 계산
-- 미들웨어에 따라 표현의 차이가 커서
-- 수치 또는 문자열로 계산하는 것이 좋음 */
SELECT
    user_id
    , SUBSTRING(register_stamp, 1, 10) AS register_date
    , birth_date
    , FLOOR(
        ( CAST(REPLACE(SUBSTRING(register_stamp, 1, 10), '-', '') AS SIGNED)
          - CAST(REPLACE(birth_date, '-', '') AS SIGNED)
        ) / 10000
     ) AS register_age
    , FLOOR(
        ( CAST(REPLACE(CAST(CURRENT_DATE AS CHAR), '-', '') AS SIGNED)
          - CAST(REPLACE(birth_date, '-', '') AS SIGNED)
        ) / 10000
     ) AS current_age
FROM
    mst_users_with_dates
;
-- +---------+---------------+------------+--------------+-------------+
-- | user_id | register_date | birth_date | register_age | current_age |
-- +---------+---------------+------------+--------------+-------------+
-- | U001    | 2016-02-28    | 2000-02-29 |           15 |          21 |
-- | U002    | 2016-02-29    | 2000-02-29 |           16 |          21 |
-- | U003    | 2016-03-01    | 2000-02-29 |           16 |          21 |
-- +---------+---------------+------------+--------------+-------------+