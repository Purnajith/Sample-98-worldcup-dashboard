-- Total page views

select count(userid) TotalPageVisits
from formatedLogPageViews;

--Total unique page visits by client
with content as ( 
                    select userid, requestUrl
                    from formatedLogPageViews 
                    group by userid, requestUrl
                )
select count(*) UniquePageVisitsByClient
from  content;

-- avarage page visits perday
with content as ( 
                    select requestDate, count(userid) visitCount
                    from formatedLogPageViews 
                    group by requestDate
                )
select avg(visitCount) AverageVistPerday
from  content;

-- Histogram of number of total page visits
select hour(requestTime) as hour, count(userid) VisitCount
from formatedLogPageViews
group by hour(requestTime);