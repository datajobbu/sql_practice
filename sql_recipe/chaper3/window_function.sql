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