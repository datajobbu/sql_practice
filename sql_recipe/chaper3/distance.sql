-- 두 값의 거리(차이) 계산
DROP TABLE IF EXISTS location_1d;
CREATE TABLE location_1d (
    x1 integer
  , x2 integer
);

INSERT INTO location_1d
VALUES
    ( 5 , 10)
  , (10 ,  5)
  , (-2 ,  4)
  , ( 3 ,  3)
  , ( 0 ,  1)
;

DROP TABLE IF EXISTS location_2d;
CREATE TABLE location_2d (
    x1 integer
  , y1 integer
  , x2 integer
  , y2 integer
);

INSERT INTO location_2d
VALUES
    (0, 0, 2, 2)
  , (3, 5, 1, 2)
  , (5, 3, 2, 1)
;

/*
-- RMS 계산
*/
SELECT
    ABS(x1 - x2) AS abs
    , SQRT(POWER(x1 - x2, 2)) AS rms
FROM
    location_1d
;
-- +------+------+
-- | abs  | rms  |
-- +------+------+
-- |    5 |    5 |
-- |    5 |    5 |
-- |    6 |    6 |
-- |    0 |    0 |
-- |    1 |    1 |
-- +------+------+