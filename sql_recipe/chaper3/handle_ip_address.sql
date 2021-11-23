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