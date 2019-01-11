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
                                        size INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ' ' STORED AS TEXTFILE LOCATION '/data/hive/warehouse/unstructuredLog'; 
                                        
-- load data to the external table
LOAD DATA INPATH "/data/hive/logs" INTO TABLE unstructuredLog; 

-- create a internal table with the formated data so that we are able to genarate formated content 
CREATE TABLE formatedLogPageViews(userID INT, 
                                    requestDate DATE, 
                                    requestTime STRING, -- cant create timestamps ? 
                                    fullDate STRING, 
                                    protocol STRING, 
                                    language STRING, 
                                    requestUrl STRING, 
                                    type STRING, 
                                    state SMALLINT, 
                                    size BIGINT ); 

-- load data to temp table by formating them 
insert into formatedLogPageViews 
select  userID, 
        from_unixtime(unix_timestamp(requestDate, "[dd/MMM/yyyy:hh:mm:ss"), "yyyy-MM-dd") as requestDate, 
        from_unixtime(unix_timestamp(requestDate, "[dd/MMM/yyyy:hh:mm:ss"), "HH:mm:ss") as requestTime, 
        from_unixtime(unix_timestamp(requestDate, "[dd/MMM/yyyy:hh:mm:ss"), "yyyy-MM-dd HH:mm:ss") as requestFullDate, 
        cast(substr(requesttype, 2, 4) as STRING) as requestType, 
        split(requestUrl, '/')[1] as language, 
        requestUrl, 
        substr(requestState, 1, 8), 
        responsetState, size 
from unstructuredLog where requestUrl like '%.htm%' -- pick only page level data so that as we are dashboading using the page views;
