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