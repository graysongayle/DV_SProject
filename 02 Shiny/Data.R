
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)




df1 <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                """select x2004, x2013 from countries
where indicator_name = \\\'Patent applications, residents\\\' and x2004 is not null and x2013 is not null
                                                
                                                """
                                                ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gmg954', PASS='orcl_gmg954', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE))); 

View(df1)


ggplot(df1, aes(x=X2004, y=X2013)) +
  geom_point(shape=1) + labs(title='Patent Applicants from 2004 and 2013') + labs(x=paste("Number of Patent Applicants 2004"), y=paste("Number of Patent Applicants 2013"))


