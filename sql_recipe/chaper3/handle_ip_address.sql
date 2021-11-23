-- IP 주소 다루기

/*
-- 정수형으로 처리
-- SUBSTRING_INDEX 보단 REGEXP_SUBSTR이 낫다. */
SELECT
    ip
    , CAST(REGEXP_SUBSTR(ip, '[^.]+', 1, 1) AS SIGNED) AS ip_part_1
    , CAST(REGEXP_SUBSTR(ip, '[^.]+', 1, 2) AS SIGNED) AS ip_part_2
    , CAST(REGEXP_SUBSTR(ip, '[^.]+', 1, 3) AS SIGNED) AS ip_part_3
    , CAST(REGEXP_SUBSTR(ip, '[^.]+', 1, 4) AS SIGNED) AS ip_part_4
FROM
    (SELECT '192.168.0.1' AS ip) AS t
;
-- +-------------+-----------+-----------+-----------+-----------+
-- | ip          | ip_part_1 | ip_part_2 | ip_part_3 | ip_part_4 |
-- +-------------+-----------+-----------+-----------+-----------+
-- | 192.168.0.1 |       192 |       168 |         0 |         1 |
-- +-------------+-----------+-----------+-----------+-----------+

/*
-- IP 주소를 값으로 변경
*/
SELECT
    ip
    , CAST(REGEXP_SUBSTR(ip, '[^.]+', 1, 1) AS SIGNED) * POWER(2, 24)
      + CAST(REGEXP_SUBSTR(ip, '[^.]+', 1, 2) AS SIGNED) * POWER(2, 16)
      + CAST(REGEXP_SUBSTR(ip, '[^.]+', 1, 3) AS SIGNED) * POWER(2, 8)
      + CAST(REGEXP_SUBSTR(ip, '[^.]+', 1, 4) AS SIGNED) * POWER(2, 0)
      AS ip_integer
FROM
    (SELECT '192.168.0.1' AS ip) AS t
;
-- +-------------+------------+
-- | ip          | ip_integer |
-- +-------------+------------+
-- | 192.168.0.1 | 3232235521 |
-- +-------------+------------+