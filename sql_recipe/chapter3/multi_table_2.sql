-- mst_users_with_card_number
DROP TABLE IF EXISTS mst_users_with_card_number;
CREATE TABLE mst_users_with_card_number (
    user_id     varchar(255)
  , card_number varchar(255)
);

INSERT INTO mst_users_with_card_number
VALUES
    ('U001', '1234-xxxx-xxxx-xxxx')
  , ('U002', Null)
  , ('U003', '5678-xxxx-xxxx-xxxx')
;

DROP TABLE IF EXISTS purchase_log_card;
CREATE TABLE purchase_log_card (
    purchase_id integer
  , user_id     varchar(255)
  , amount      integer
  , stamp       varchar(255)
);

INSERT INTO purchase_log_card
VALUES
    (10001, 'U001', 200, '2017-01-30 10:00:00')
  , (10002, 'U001', 500, '2017-02-10 10:00:00')
  , (10003, 'U001', 200, '2017-02-12 10:00:00')
  , (10004, 'U002', 800, '2017-03-01 10:00:00')
  , (10005, 'U002', 400, '2017-03-02 10:00:00')
;

/*
-- FLAG with SIGN()
*/
SELECT
    m.user_id
    , m.card_number
    , COUNT(p.user_id) AS purchase_count
    , CASE WHEN m.card_number IS NOT NULL THEN 1 ELSE 0 END AS has_card
    , SIGN(COUNT(p.user_id)) AS has_purchased
FROM
    mst_users_with_card_number AS m
    LEFT JOIN
        purchase_log_card AS p
        ON m.user_id = p.user_id
GROUP BY
    m.user_id, m.card_number
;
-- +---------+---------------------+----------------+----------+---------------+
-- | user_id | card_number         | purchase_count | has_card | has_purchased |
-- +---------+---------------------+----------------+----------+---------------+
-- | U001    | 1234-xxxx-xxxx-xxxx |              3 |        1 |             1 |
-- | U002    | NULL                |              2 |        0 |             1 |
-- | U003    | 5678-xxxx-xxxx-xxxx |              0 |        1 |             0 |
-- +---------+---------------------+----------------+----------+---------------+