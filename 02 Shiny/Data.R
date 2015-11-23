
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

KPI_Low_Max_value <- reactive({input$KPI1})  
KPI_Medium_Max_value <- reactive({input$KPI2})  
df2 <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                                               """select country_name, indicator_name, avg(X2005)-avg(x2004) as kpi, avg(x2005) as AMOUNT,
                                                                                case
                                                 when kpi < "p1" then \\\'03 Low\\\'
                                                 when kpi < "p2" then \\\'02 Medium\\\'
                                                 else \\\'01 High\\\'
                                                 end kpi
                                                 from countries
                                                 where country_name in (\\\'Belgium\\\',\\\'Brazil\\\',\\\'Czech Republic\\\', \\\'Korea, Rep.\\\',\\\'Mexico\\\') and indicator_code in (\\\'IP.TMK.NRES\\\',\\\'IP.TMK.RESD\\\',\\\'IP.TMK.TOTL\\\')
                                                 group by country_name, indicator_name
                                                 order by country_name""
                                                                               ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gmg954', PASS='orcl_gmg954', 
                                                                                                 MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON',p1=KPI_Low_Max_value(), p2=KPI_Medium_Max_value()), verbose = TRUE)));
df1 <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                                               "select x2004, x2013 from countries
                                                                               where indicator_name = \\\'Patent applications, residents\\\' and x2012 is not null and x2013 is not null"
                                                                               ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gmg954', PASS='orcl_gmg954', 
                                                                                                 MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
plot <- 
  ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  #facet_wrap(~CLARITY, ncol=1) +
  labs(title='Patent applicants from 2003 to 2014') +
  labs(x=paste("Year 2004"), y=paste("Year 2013")) +
  layer(data=df1, 
        mapping=aes(x=X2004, y=X2013), 
        stat="identity", 
        #stat_params=list(binwidth = 0.5), 
        geom="point",
        #geom_params=list(colour=NA), 
        position = position_identity()
  ) 


plot

View(df2)

plot <- ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title="test") +
  labs(x=paste("INDICATOR_NAME"), y=paste("COUNTRY_NAME")) +
  layer(data=df2, 
        mapping=aes(x=INDICATOR_NAME, y=COUNTRY_NAME, label =AMOUNT), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black"), 
        position=position_identity()
  ) +
  layer(data=df2, 
        mapping=aes(x=INDICATOR_NAME, y=COUNTRY_NAME, fill=KPI), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=.5), 
        position=position_identity()
  )
plot


