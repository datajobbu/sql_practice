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