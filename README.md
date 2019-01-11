# Sample-98-worldcup-dashboard

This project is providing a dashbaord for 1998 football world cup http log data

Datasource : http://ita.ee.lbl.gov/html/contrib/WorldCup.html

Match Times : http://www.worldfootball.net/all_matches/wm-1998-in-frankreich/

Log format 
55 - - [30/Apr/1998:21:38:59 +0000] "GET /french/index.html HTTP/1.0" 200 985
• 55 : Client ID
• [30/Apr/1998:21:38:59 +0000] : Time in GMT
• french : page language
• /french/index.html HTTP/1.0 : url
• 200 : HTTP status code
• 985 : bytes transferred
