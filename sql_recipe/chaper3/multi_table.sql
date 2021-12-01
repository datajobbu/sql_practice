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