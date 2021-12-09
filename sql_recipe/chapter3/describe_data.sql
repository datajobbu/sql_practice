-- 테이블 전체의 특징량 계산
DROP TABLE IF EXISTS review;
CREATE TABLE review (
    user_id    varchar(255)
  , product_id varchar(255)
  , score      numeric
);

INSERT INTO review
VALUES
    ('U001', 'A001', 4.0)
  , ('U001', 'A002', 5.0)
  , ('U001', 'A003', 5.0)
  , ('U002', 'A001', 3.0)
  , ('U002', 'A002', 3.0)
  , ('U002', 'A003', 4.0)
  , ('U003', 'A001', 5.0)
  , ('U003', 'A002', 4.0)
  , ('U003', 'A003', 4.0)
;

/*
-- 집계 함수
-- COUNT, SUM, AVG, MAX, MIN */
SELECT
    COUNT(*) AS total_cnt
    , COUNT(DISTINCT user_id) AS user_cnt
    , COUNT(DISTINCT product_id) AS product_cnt
    , SUM(score) AS sum
    , AVG(score) AS avg
    , MAX(score) AS max
    , MIN(score) AS min
FROM
    review
;
-- +-----------+----------+-------------+------+--------+------+------+
-- | total_cnt | user_cnt | product_cnt | sum  | avg    | max  | min  |
-- +-----------+----------+-------------+------+--------+------+------+
-- |         9 |        3 |           3 |   37 | 4.1111 |    5 |    3 |
-- +-----------+----------+-------------+------+--------+------+------+

/*
-- 집계 함수 w 그루핑
-- GROUP BY */
SELECT
    user_id
    , COUNT(*) AS total_cnt
    , COUNT(DISTINCT user_id) AS user_cnt
    , COUNT(DISTINCT product_id) AS product_cnt
    , SUM(score) AS sum
    , AVG(score) AS avg
    , MAX(score) AS max
    , MIN(score) AS min
FROM
    review
GROUP BY
    user_id
;
-- +---------+-----------+----------+-------------+------+--------+------+------+
-- | user_id | total_cnt | user_cnt | product_cnt | sum  | avg    | max  | min  |
-- +---------+-----------+----------+-------------+------+--------+------+------+
-- | U001    |         3 |        1 |           3 |   14 | 4.6667 |    5 |    4 |
-- | U002    |         3 |        1 |           3 |   10 | 3.3333 |    4 |    3 |
-- | U003    |         3 |        1 |           3 |   13 | 4.3333 |    5 |    4 |
-- +---------+-----------+----------+-------------+------+--------+------+------+

/*
-- 집계함수 w Window Function
*/
SELECT
    user_id
    , product_id
    , score
    , AVG(score) OVER() AS avg_score
    , AVG(score) OVER(PARTITION BY user_id) AS user_avg_score
    , score - AVG(score) OVER(PARTITION BY user_id) AS user_avg_score_diff
FROM
    review
;
-- +---------+------------+-------+-----------+----------------+---------------------+
-- | user_id | product_id | score | avg_score | user_avg_score | user_avg_score_diff |
-- +---------+------------+-------+-----------+----------------+---------------------+
-- | U001    | A001       |     4 |    4.1111 |         4.6667 |             -0.6667 |
-- | U001    | A002       |     5 |    4.1111 |         4.6667 |              0.3333 |
-- | U001    | A003       |     5 |    4.1111 |         4.6667 |              0.3333 |
-- | U002    | A001       |     3 |    4.1111 |         3.3333 |             -0.3333 |
-- | U002    | A002       |     3 |    4.1111 |         3.3333 |             -0.3333 |
-- | U002    | A003       |     4 |    4.1111 |         3.3333 |              0.6667 |
-- | U003    | A001       |     5 |    4.1111 |         4.3333 |              0.6667 |
-- | U003    | A002       |     4 |    4.1111 |         4.3333 |             -0.3333 |
-- | U003    | A003       |     4 |    4.1111 |         4.3333 |             -0.3333 |
-- +---------+------------+-------+-----------+----------------+---------------------+