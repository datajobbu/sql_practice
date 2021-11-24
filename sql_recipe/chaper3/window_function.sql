-- Window Function
DROP TABLE IF EXISTS popular_products;
CREATE TABLE popular_products (
    product_id varchar(255)
  , category   varchar(255)
  , score      numeric
);

INSERT INTO popular_products
VALUES
    ('A001', 'action', 94)
  , ('A002', 'action', 81)
  , ('A003', 'action', 78)
  , ('A004', 'action', 64)
  , ('D001', 'drama' , 90)
  , ('D002', 'drama' , 82)
  , ('D003', 'drama' , 78)
  , ('D004', 'drama' , 58)
;

/*
-- Window + Order By
*/
SELECT
    product_id
    , score
    , ROW_NUMBER() OVER(ORDER BY score DESC) AS 'row'
    , RANK() OVER(ORDER BY score DESC) AS 'rank'
    , DENSE_RANK() OVER(ORDER BY score DESC) AS 'dense'
    , LAG(product_id) OVER(ORDER BY score DESC) AS 'lag1'
    , LAG(product_id, 2) OVER(ORDER BY score DESC) AS 'lag2'
    , LEAD(product_id) OVER(ORDER BY score DESC) AS 'lead1'
    , LEAD(product_id, 2) OVER(ORDER BY score DESC) AS 'lead2'
FROM
    popular_products
ORDER BY
    score DESC
;
-- +------------+-------+-----+------+-------+------+------+-------+-------+
-- | product_id | score | row | rank | dense | lag1 | lag2 | lead1 | lead2 |
-- +------------+-------+-----+------+-------+------+------+-------+-------+
-- | A001       |    94 |   1 |    1 |     1 | NULL | NULL | D001  | D002  |
-- | D001       |    90 |   2 |    2 |     2 | A001 | NULL | D002  | A002  |
-- | D002       |    82 |   3 |    3 |     3 | D001 | A001 | A002  | A003  |
-- | A002       |    81 |   4 |    4 |     4 | D002 | D001 | A003  | D003  |
-- | A003       |    78 |   5 |    5 |     5 | A002 | D002 | D003  | A004  |
-- | D003       |    78 |   6 |    5 |     5 | A003 | A002 | A004  | D004  |
-- | A004       |    64 |   7 |    7 |     6 | D003 | A003 | D004  | NULL  |
-- | D004       |    58 |   8 |    8 |     7 | A004 | D003 | NULL  | NULL  |
-- +------------+-------+-----+------+-------+------+------+-------+-------+

-- 같은 결과를 내는 쿼리
SELECT
    product_id
    , score
    , ROW_NUMBER() OVER w AS 'row'
    , RANK() OVER w AS 'rank'
    , DENSE_RANK() OVER w AS 'dense'
    , LAG(product_id) OVER w AS 'lag1'
    , LAG(product_id, 2) OVER w AS 'lag2'
    , LEAD(product_id) OVER w AS 'lead1'
    , LEAD(product_id, 2) OVER w AS 'lead2'
FROM
    popular_products
WINDOW
    w AS (ORDER BY score DESC)
;

/* 
-- WINDOW + ORDER BY + DESCRIBE
*/
SELECT
    product_id
    , score
    , ROW_NUMBER() OVER(ORDER BY score DESC) AS 'row'
    , SUM(score)
        OVER(ORDER BY score DESC
             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
      AS cum_score
    , AVG(score)
        OVER(ORDER BY score DESC
             ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
      AS local_avg
    , FIRST_VALUE(product_id)
        OVER(ORDER BY score DESC
             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
      AS 'first_value'
    , LAST_VALUE(product_id)
        OVER(ORDER BY score DESC
             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
      AS 'last_value'
FROM
    popular_products
ORDER BY
    'row'
;
-- +------------+-------+-----+-----------+-----------+-------------+------------+
-- | product_id | score | row | cum_score | local_avg | first_value | last_value |
-- +------------+-------+-----+-----------+-----------+-------------+------------+
-- | A001       |    94 |   1 |        94 |   92.0000 | A001        | D004       |
-- | D001       |    90 |   2 |       184 |   88.6667 | A001        | D004       |
-- | D002       |    82 |   3 |       266 |   84.3333 | A001        | D004       |
-- | A002       |    81 |   4 |       347 |   80.3333 | A001        | D004       |
-- | A003       |    78 |   5 |       425 |   79.0000 | A001        | D004       |
-- | D003       |    78 |   6 |       503 |   73.3333 | A001        | D004       |
-- | A004       |    64 |   7 |       567 |   66.6667 | A001        | D004       |
-- | D004       |    58 |   8 |       625 |   61.0000 | A001        | D004       |
-- +------------+-------+-----+-----------+-----------+-------------+------------+