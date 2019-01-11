DROP TABLE unstructuredLog;

-- create external table so that we are able to reload the data when needed 
CREATE EXTERNAL TABLE unstructuredLog(userID INT, 
                                        dash STRING, 
                                        dash2 STRING, 
                                        requestDate STRING, 
                                        requestTime string, 
                                        requesttype STRING, 
                                        requestUrl STRING, 
                                        requestState STRING, 
                                        responsetState INT, 
                                        size INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ' ' STORED AS TEXTFILE LOCATION '/data/mediumartical/hive/warehouse/unstructuredLog'; 
                                        
-- load data to the external table
LOAD DATA INPATH "/data/mediumartical/hive/extracts/logs" INTO TABLE unstructuredLog; 

DROP TABLE formatedLogPageViews;

-- create a internal table with the formated data so that we are able to genarate formated content 
CREATE TABLE formatedLogPageViews(userID INT, 
                                    requestDate DATE, 
                                    requestTime STRING,
                                    fullDate STRING, 
                                    protocol STRING, 
                                    language STRING, 
                                    requestUrl STRING, 
                                    type STRING, 
                                    state SMALLINT, 
                                    size BIGINT ); 

-- load data to temp table by formating them 
INSERT INTO formatedLogPageViews 
SELECT  userID, 
        from_unixtime(unix_timestamp(requestDate, "[dd/MMM/yyyy:hh:mm:ss"), "yyyy-MM-dd") as requestDate, 
        from_unixtime(unix_timestamp(requestDate, "[dd/MMM/yyyy:hh:mm:ss"), "HH:mm:ss") as requestTime, 
        from_unixtime(unix_timestamp(requestDate, "[dd/MMM/yyyy:hh:mm:ss"), "yyyy-MM-dd HH:mm:ss") as requestFullDate, 
        cast(substr(requesttype, 2, 4) as STRING) as requestType, 
        split(requestUrl, '/')[1] as language, 
        requestUrl, 
        substr(requestState, 1, 8), 
        responsetState, size 
FROM    unstructuredLog 
WHERE   requestUrl LIKE '%.htm%'; 
-- pick only page level data so that as we are dashboading using the page views;



SELECT  * 
FROM    formatedLogPageViews 
LIMIT   10;