
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

# The following is equivalent to "04 Blending 2 Data Sources.twb"

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
  """select country_name , indicator_name , avg(X2013) as Y from countries
where country_code = \\\'JAP\\\'
                                                group by country_name,  indicator_name
                                                having avg(X2013) is not null
                                                order by avg(x2013) desc
                                                
"""
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gmg954', PASS='orcl_gmg954', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE))); 

View(df)