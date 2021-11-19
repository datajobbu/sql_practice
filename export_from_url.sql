-- 호스트 추출
-- BigQuery 등에는 URL을 다루는 함수가 있지만, MySQL은 없으므로
-- 복잡한 쿼리문 필요
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

SELECT 
    stamp
    , REGEXP_REPLACE(REGEXP_SUBSTR(referrer, 'https?://[^/]*'), 'https?://', '') AS referrer_host
FROM access_log;