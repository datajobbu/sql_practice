-- 쿼리로 URL 처리
-- 테이블 생성
DROP TABLE IF EXISTS access_log ;
CREATE TABLE access_log (
    stamp    varchar(255)
  , referrer text
  , url      text
);

INSERT INTO access_log 
VALUES
    ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001')
  , ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref'          )
  , ('2016-08-26 12:02:01', 'https://www.other.com/'                               , 'http://www.example.com/book/detail?id=002' )
;

/* 호스트 추출
-- BigQuery 등에는 URL을 다루는 함수가 있지만, MySQL은 없으므로
-- 복잡한 쿼리문 필요 */
SELECT 
    stamp
    , REGEXP_REPLACE(REGEXP_SUBSTR(referrer, 'https?://[^/]*'), 'https?://', '') AS referrer_host
FROM access_log;
-- +---------------------+---------------+
-- | stamp               | referrer_host |
-- +---------------------+---------------+
-- | 2016-08-26 12:02:00 | www.other.com |
-- | 2016-08-26 12:02:01 | www.other.net |
-- | 2016-08-26 12:02:01 | www.other.com |
-- +---------------------+---------------+

/*
-- URL 경로, GET 매개변수 id 추출
*/
SELECT
    stamp
    , url
    , REGEXP_REPLACE(REGEXP_SUBSTR(url, '//[^/]+[^?#]+'), '//[^/]+', '') AS path
    , REGEXP_REPLACE(REGEXP_SUBSTR(url, 'id=[^&]*'), 'id=', '') AS id
FROM access_log;
-- +---------------------+--------------------------------------------+---------------+------+
-- | stamp               | url                                        | path          | id   |
-- +---------------------+--------------------------------------------+---------------+------+
-- | 2016-08-26 12:02:00 | http://www.example.com/video/detail?id=001 | /video/detail | 001  |
-- | 2016-08-26 12:02:01 | http://www.example.com/video#ref           | /video        | NULL |
-- | 2016-08-26 12:02:01 | http://www.example.com/book/detail?id=002  | /book/detail  | 002  |
-- +---------------------+--------------------------------------------+---------------+------+

/*
-- 문자열을 배열로 분해
*/
SELECT
  stamp
  , url
  , REGEXP_SUBSTR(REGEXP_REPLACE(REGEXP_SUBSTR(url, '//[^/]+([^?#]+)'), '//[^/]+', ''), '[^/]+', 1, 1) AS path1
  , REGEXP_SUBSTR(REGEXP_REPLACE(REGEXP_SUBSTR(url, '//[^/]+([^?#]+)'), '//[^/]+', ''), '[^/]+', 1, 2) AS path2
FROM access_log;
-- +---------------------+--------------------------------------------+-------+--------+
-- | stamp               | url                                        | path1 | path2  |
-- +---------------------+--------------------------------------------+-------+--------+
-- | 2016-08-26 12:02:00 | http://www.example.com/video/detail?id=001 | video | detail |
-- | 2016-08-26 12:02:01 | http://www.example.com/video#ref           | video | NULL   |
-- | 2016-08-26 12:02:01 | http://www.example.com/book/detail?id=002  | book  | detail |
-- +---------------------+--------------------------------------------+-------+--------+