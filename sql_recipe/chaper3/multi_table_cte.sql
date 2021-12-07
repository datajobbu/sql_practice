-- product_sales table
DROP TABLE IF EXISTS product_sales;
CREATE TABLE product_sales (
    category_name varchar(255)
  , product_id    varchar(255)
  , sales         integer
);

INSERT INTO product_sales
VALUES
    ('dvd', 'D001', 50000)
    , ('dvd', 'D002', 20000)
    , ('dvd', 'D003', 10000)
    , ('cd', 'C001', 30000)
    , ('cd', 'C002', 20000)
    , ('cd', 'C003', 10000)
    , ('book', 'B001', 20000)
    , ('book', 'B002', 15000)
    , ('book', 'B003', 10000)
    , ('book', 'B004', 5000)
;

/*
-- Rank By Category
-- CTE WITH ROW_NUMBER */
WITH
    product_sale_ranking AS (
        SELECT
            category_name
            , product_id
            , sales
            , ROW_NUMBER() OVER(
                PARTITION BY category_name
                ORDER BY sales
                DESC
             ) AS ranks
        FROM
            product_sales
    )

SELECT
    *
FROM
    product_sale_ranking
;
-- +---------------+------------+-------+-------+
-- | category_name | product_id | sales | ranks |
-- +---------------+------------+-------+-------+
-- | book          | B001       | 20000 |     1 |
-- | book          | B002       | 15000 |     2 |
-- | book          | B003       | 10000 |     3 |
-- | book          | B004       |  5000 |     4 |
-- | cd            | C001       | 30000 |     1 |
-- | cd            | C002       | 20000 |     2 |
-- | cd            | C003       | 10000 |     3 |
-- | dvd           | D001       | 50000 |     1 |
-- | dvd           | D002       | 20000 |     2 |
-- | dvd           | D003       | 10000 |     3 |
-- +---------------+------------+-------+-------+

/*
-- Category Rank Result As Horizontal
-- CTE WITH JOIN */
WITH
    product_sale_ranking AS (
        SELECT
            category_name
            , product_id
            , sales
            , ROW_NUMBER() OVER(
                PARTITION BY category_name
                ORDER BY sales
                DESC
             ) AS ranks
        FROM
            product_sales
    )
    , mst_rank AS (
        SELECT DISTINCT
            ranks
        FROM
            product_sale_ranking
    )

SELECT
    m.ranks
    , r1.product_id AS dvd
    , r1.sales AS dvd_sales
    , r2.product_id AS cd
    , r2.sales AS cd_sales
    , r3.product_id AS book
    , r3.sales AS book_sales
FROM
    mst_rank AS m
    LEFT JOIN
        product_sale_ranking AS r1
        ON m.ranks = r1.ranks
        AND r1.category_name = 'dvd'
    LEFT JOIN
        product_sale_ranking AS r2
        ON m.ranks = r2.ranks
        AND r2.category_name = 'cd'
    LEFT JOIN
        product_sale_ranking AS r3
        ON m.ranks = r3.ranks
        AND r3.category_name = 'book'
ORDER BY
    m.ranks
;
-- +-------+------+-----------+------+----------+------+------------+
-- | ranks | dvd  | dvd_sales | cd   | cd_sales | book | book_sales |
-- +-------+------+-----------+------+----------+------+------------+
-- |     1 | D001 |     50000 | C001 |    30000 | B001 |      20000 |
-- |     2 | D002 |     20000 | C002 |    20000 | B002 |      15000 |
-- |     3 | D003 |     10000 | C003 |    10000 | B003 |      10000 |
-- |     4 | NULL |      NULL | NULL |     NULL | B004 |       5000 |
-- +-------+------+-----------+------+----------+------+------------+