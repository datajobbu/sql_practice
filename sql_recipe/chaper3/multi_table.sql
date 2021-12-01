-- 여러 개의 테이블 조작
DROP TABLE IF EXISTS app1_mst_users;
CREATE TABLE app1_mst_users (
    user_id varchar(255)
  , name    varchar(255)
  , email   varchar(255)
);

INSERT INTO app1_mst_users
VALUES
    ('U001', 'Sato'  , 'sato@example.com'  )
  , ('U002', 'Suzuki', 'suzuki@example.com')
;

DROP TABLE IF EXISTS app2_mst_users;
CREATE TABLE app2_mst_users (
    user_id varchar(255)
  , name    varchar(255)
  , phone   varchar(255)
);

INSERT INTO app2_mst_users
VALUES
    ('U001', 'Ito'   , '080-xxxx-xxxx')
  , ('U002', 'Tanaka', '070-xxxx-xxxx')
;

/*
-- Concat Table(Vertical)
-- UNION ALL */
SELECT
    'app1' AS app_name
    , user_id
    , name
    , email
FROM
    app1_mst_users

UNION ALL

SELECT
    'app2' AS app_name
    , user_id
    , name
    , NULL AS email
FROM
    app2_mst_users
;
-- +----------+---------+--------+--------------------+
-- | app_name | user_id | name   | email              |
-- +----------+---------+--------+--------------------+
-- | app1     | U001    | Sato   | sato@example.com   |
-- | app1     | U002    | Suzuki | suzuki@example.com |
-- | app2     | U001    | Ito    | NULL               |
-- | app2     | U002    | Tanaka | NULL               |
-- +----------+---------+--------+--------------------+

DROP TABLE IF EXISTS mst_categories;
CREATE TABLE mst_categories (
    category_id integer
  , name        varchar(255)
);

INSERT INTO mst_categories
VALUES
    (1, 'dvd' )
  , (2, 'cd'  )
  , (3, 'book')
;

DROP TABLE IF EXISTS category_sales;
CREATE TABLE category_sales (
    category_id integer
  , sales       integer
);

INSERT INTO category_sales
VALUES
    (1, 850000)
  , (2, 500000)
;

DROP TABLE IF EXISTS product_sale_ranking;
CREATE TABLE product_sale_ranking (
    category_id integer
  , ranks      integer
  , product_id  varchar(255)
  , sales       integer
);

INSERT INTO product_sale_ranking
VALUES
    (1, 1, 'D001', 50000)
  , (1, 2, 'D002', 20000)
  , (1, 3, 'D003', 10000)
  , (2, 1, 'C001', 30000)
  , (2, 2, 'C002', 20000)
  , (2, 3, 'C003', 10000)
;

/*
-- Concat Table(Horizontal)
-- JOIN */
SELECT
    m.category_id
    , m.name
    , s.sales
    , r.product_id AS sale_product
FROM
    mst_categories AS m
    JOIN
        category_sales AS s
        ON m.category_id = s.category_id
    JOIN
        product_sale_ranking AS r
        ON m.category_id = r.category_id
;
-- +-------------+------+--------+--------------+
-- | category_id | name | sales  | sale_product |
-- +-------------+------+--------+--------------+
-- |           1 | dvd  | 850000 | D001         |
-- |           1 | dvd  | 850000 | D002         |
-- |           1 | dvd  | 850000 | D003         |
-- |           2 | cd   | 500000 | C001         |
-- |           2 | cd   | 500000 | C002         |
-- |           2 | cd   | 500000 | C003         |
-- +-------------+------+--------+--------------+

/*
-- Concat Horizonal wtih TOP 1 item
-- LEFT JOIN */
SELECT
    m.category_id
    , m.name
    , s.sales
    , r.product_id AS top_sale_product
FROM
    mst_categories AS m
    LEFT JOIN
        category_sales AS s
        ON m.category_id = s.category_id
    LEFT JOIN
        product_sale_ranking AS r
        ON m.category_id = r.category_id
        AND r.ranks = 1
;
-- +-------------+------+--------+------------------+
-- | category_id | name | sales  | top_sale_product |
-- +-------------+------+--------+------------------+
-- |           1 | dvd  | 850000 | D001             |
-- |           2 | cd   | 500000 | C001             |
-- |           3 | book |   NULL | NULL             |
-- +-------------+------+--------+------------------+