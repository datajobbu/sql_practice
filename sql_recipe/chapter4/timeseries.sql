-- purchase_log
DROP TABLE IF EXISTS purchase_log;
CREATE TABLE purchase_log(
    dt              varchar(255)
  , order_id        integer
  , user_id         varchar(255)
  , purchase_amount integer
);

INSERT INTO purchase_log
VALUES
    ('2014-01-01',  1, 'rhwpvvitou', 13900)
  , ('2014-01-01',  2, 'hqnwoamzic', 10616)
  , ('2014-01-02',  3, 'tzlmqryunr', 21156)
  , ('2014-01-02',  4, 'wkmqqwbyai', 14893)
  , ('2014-01-03',  5, 'ciecbedwbq', 13054)
  , ('2014-01-03',  6, 'svgnbqsagx', 24384)
  , ('2014-01-03',  7, 'dfgqftdocu', 15591)
  , ('2014-01-04',  8, 'sbgqlzkvyn',  3025)
  , ('2014-01-04',  9, 'lbedmngbol', 24215)
  , ('2014-01-04', 10, 'itlvssbsgx',  2059)
  , ('2014-01-05', 11, 'jqcmmguhik',  4235)
  , ('2014-01-05', 12, 'jgotcrfeyn', 28013)
  , ('2014-01-05', 13, 'pgeojzoshx', 16008)
  , ('2014-01-06', 14, 'msjberhxnx',  1980)
  , ('2014-01-06', 15, 'tlhbolohte', 23494)
  , ('2014-01-06', 16, 'gbchhkcotf',  3966)
  , ('2014-01-07', 17, 'zfmbpvpzvu', 28159)
  , ('2014-01-07', 18, 'yauwzpaxtx',  8715)
  , ('2014-01-07', 19, 'uyqboqfgex', 10805)
  , ('2014-01-08', 20, 'hiqdkrzcpq',  3462)
  , ('2014-01-08', 21, 'zosbvlylpv', 13999)
  , ('2014-01-08', 22, 'bwfbchzgnl',  2299)
  , ('2014-01-09', 23, 'zzgauelgrt', 16475)
  , ('2014-01-09', 24, 'qrzfcwecge',  6469)
  , ('2014-01-10', 25, 'njbpsrvvcq', 16584)
  , ('2014-01-10', 26, 'cyxfgumkst', 11339)
;

/*
-- 날짜별 매출과 평군 구매액 집계
*/
SELECT
    dt
    , COUNT(*) AS purchase_count
    , SUM(purchase_amount) AS total_amount
    , AVG(purchase_amount) AS avg_amount
FROM purchase_log
GROUP BY dt
ORDER BY dt
;
-- +------------+----------------+--------------+------------+
-- | dt         | purchase_count | total_amount | avg_amount |
-- +------------+----------------+--------------+------------+
-- | 2014-01-01 |              2 |        24516 | 12258.0000 |
-- | 2014-01-02 |              2 |        36049 | 18024.5000 |
-- | 2014-01-03 |              3 |        53029 | 17676.3333 |
-- | 2014-01-04 |              3 |        29299 |  9766.3333 |
-- | 2014-01-05 |              3 |        48256 | 16085.3333 |
-- | 2014-01-06 |              3 |        29440 |  9813.3333 |
-- | 2014-01-07 |              3 |        47679 | 15893.0000 |
-- | 2014-01-08 |              3 |        19760 |  6586.6667 |
-- | 2014-01-09 |              2 |        22944 | 11472.0000 |
-- | 2014-01-10 |              2 |        27923 | 13961.5000 |
-- +------------+----------------+--------------+------------+