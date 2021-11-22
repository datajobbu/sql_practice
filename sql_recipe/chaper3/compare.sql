-- 여러 개의 값 비교
DROP TABLE IF EXISTS quarterly_sales;
CREATE TABLE quarterly_sales (
    year integer
  , q1   integer
  , q2   integer
  , q3   integer
  , q4   integer
);

INSERT INTO quarterly_sales
VALUES
    (2015, 82000, 83000, 78000, 83000)
  , (2016, 85000, 85000, 80000, 81000)
  , (2017, 92000, 81000, NULL , NULL )
;

/*
-- q1, q2 컬럼 비교
*/
SELECT
    year
    , q1
    , q2
    , CASE
        WHEN q1 < q2 THEN '+'
        WHEN q1 = q2 THEN ' '
        ELSE '-'
    END AS judge_q1_q2
    , q2 - q1 AS diff_q2_q1
    , SIGN(q2 - q1) AS sign_q2_q1
FROM
    quarterly_sales
ORDER BY
    year
;
-- +------+-------+-------+-------------+------------+------------+
-- | year | q1    | q2    | judge_q1_q2 | diff_q2_q1 | sign_q2_q1 |
-- +------+-------+-------+-------------+------------+------------+
-- | 2015 | 82000 | 83000 | +           |       1000 |          1 |
-- | 2016 | 85000 | 85000 |             |          0 |          0 |
-- | 2017 | 92000 | 81000 | -           |     -11000 |         -1 |
-- +------+-------+-------+-------------+------------+------------+

/*
-- 연간 최대/최소 분기별 매출 찾기
-- MySQL에서 NULL 포함시 계산 결과도 NULL */
SELECT
    year
    , GREATEST(q1, q2, q3, q4) AS greatest_sales
    , LEAST(q1, q2, q3, q4) AS least_sales
FROM
    quarterly_sales
ORDER BY
    year
;
-- +------+----------------+-------------+
-- | year | greatest_sales | least_sales |
-- +------+----------------+-------------+
-- | 2015 |          83000 |       78000 |
-- | 2016 |          85000 |       80000 |
-- | 2017 |           NULL |        NULL |
-- +------+----------------+-------------+

/*
-- 분기별 평균 매출
*/
SELECT
    year
    , (q1 + q2 + q3 + q4) / 4 AS average
FROM
    quarterly_sales
ORDER BY
    year
;
-- +------+------------+
-- | year | average    |
-- +------+------------+
-- | 2015 | 81500.0000 |
-- | 2016 | 82750.0000 |
-- | 2017 |       NULL |
-- +------+------------+

/*
-- 분기별 평균 매출(2)
-- NULL 포함 사칙연산 처리*/
SELECT
    year
    , (COALESCE(q1, 0) 
       + COALESCE(q2, 0) 
       + COALESCE(q3, 0) 
       + COALESCE(q4, 0)
      ) / 4 AS average
FROM
    quarterly_sales
ORDER BY
    year
;
-- +------+------------+
-- | year | average    |
-- +------+------------+
-- | 2015 | 81500.0000 |
-- | 2016 | 82750.0000 |
-- | 2017 | 43250.0000 |
-- +------+------------+