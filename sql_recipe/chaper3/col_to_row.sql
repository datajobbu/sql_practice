-- 열로 표현된 값을 행으로 변환하기
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

DROP TABLE IF EXISTS purchase_log;
CREATE TABLE purchase_log (
    purchase_id integer
  , product_ids varchar(255)
);

INSERT INTO purchase_log
VALUES
    (100001, 'A001,A002,A003')
  , (100002, 'D001,D002')
  , (100003, 'A001')
;

/*
-- PIVOT TABLE
*/
SELECT
    q.year
    , CASE
        WHEN p.idx = 1 THEN 'q1'
        WHEN p.idx = 2 THEN 'q2'
        WHEN p.idx = 3 THEN 'q3'
        WHEN p.idx = 4 THEN 'q4'
      END AS quarter
    , CASE
        WHEN p.idx = 1 THEN q.q1
        WHEN p.idx = 2 THEN q.q2
        WHEN p.idx = 3 THEN q.q3
        WHEN p.idx = 4 THEN q.q4
      END AS sales
FROM
    quarterly_sales AS q
    CROSS JOIN (
        SELECT 1 AS idx
        UNION ALL SELECT 2 AS idx
        UNION ALL SELECT 3 AS idx
        UNION ALL SELECT 4 AS idx
    ) AS p
ORDER BY
    year
;
-- +------+---------+-------+
-- | year | quarter | sales |
-- +------+---------+-------+
-- | 2015 | q1      | 82000 |
-- | 2015 | q2      | 83000 |
-- | 2015 | q3      | 78000 |
-- | 2015 | q4      | 83000 |
-- | 2016 | q1      | 85000 |
-- | 2016 | q2      | 85000 |
-- | 2016 | q3      | 80000 |
-- | 2016 | q4      | 81000 |
-- | 2017 | q1      | 92000 |
-- | 2017 | q2      | 81000 |
-- | 2017 | q3      |  NULL |
-- | 2017 | q4      |  NULL |
-- +------+---------+-------+

/*
-- Table With Serial Number
*/
SELECT
    *
FROM (
    SELECT 1 AS idx
    UNION ALL SELECT 2 AS idx
    UNION ALL SELECT 3 AS idx
) AS pivot
;
-- +-----+
-- | idx |
-- +-----+
-- |   1 |
-- |   2 |
-- |   3 |
-- +-----+

/*
-- Example of SPLIT_PART
-- MySQL: REGEXP_SUBSTR() */
SELECT
    REGEXP_SUBSTR('A001,A002,A003', '[^,]+', 1, 1) AS part_1
    , REGEXP_SUBSTR('A001,A002,A003', '[^,]+', 1, 2) AS part_2
    , REGEXP_SUBSTR('A001,A002,A003', '[^,]+', 1, 3) AS part_3
;
-- +--------+--------+--------+
-- | part_1 | part_2 | part_3 |
-- +--------+--------+--------+
-- | A001   | A002   | A003   |
-- +--------+--------+--------+

/*
-- Products Count from String
*/
SELECT
    purchase_id
    , product_ids
    , 1
      + CHAR_LENGTH(product_ids)
      - CHAR_LENGTH(REPLACE(product_ids, ',', ''))
      AS product_cnt
FROM
    purchase_log
;
-- +-------------+----------------+-------------+
-- | purchase_id | product_ids    | product_cnt |
-- +-------------+----------------+-------------+
-- |      100001 | A001,A002,A003 |           3 |
-- |      100002 | D001,D002      |           2 |
-- |      100003 | A001           |           1 |
-- +-------------+----------------+-------------+