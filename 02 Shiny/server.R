# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(leaflet)
require(DT)

shinyServer(function(input, output) {
  
  KPI_Low_Max_value <- reactive({input$KPI1})     
  KPI_Medium_Max_value <- reactive({input$KPI2})
  rv <- reactiveValues(alpha = 0.50)
  observeEvent(input$light, { rv$alpha <- 0.50 })
  observeEvent(input$dark, { rv$alpha <- 0.75 })
  
  df <- eventReactive(input$clicks, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                                                "select country_name, indicator_name, avg(X2013) as Count_Sum from countries
                                                                                where country_code = \\\'JPN\\\'
                                                                                group by country_name,  indicator_name
                                                                                having avg(X2013) is not null and avg(X2013) < 1000000 and avg(x2013) >20
                                                                                order by avg(x2013) desc"
                                                                               ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gmg954', PASS='orcl_gmg954', 
                                                                                                 MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  })
  
  df1 <- eventReactive(input$clicks3, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                                               "select x2004, x2013 from countries
where indicator_name = \\\'Patent applications, residents\\\' and x2012 is not null and x2013 is not null"
                                                                               ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gmg954', PASS='orcl_gmg954', 
                                                                                                 MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  })
  
  
  

  
  output$distPlot1 <- renderPlot({             
    fancy_scientific <- function(l) {
      # turn in to character string in scientific notation
      l <- format(l, scientific = TRUE)
      # quote the part before the exponent to keep all the digits
      l <- gsub("^(.*)e", "'\\1'e", l)
      # turn the 'e+' into plotmath format
      l <- gsub("e", "%*%10^", l)
      # return this as an expression
      parse(text=l)
    }
    
    plot <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_continuous(labels = fancy_scientific) +
      #facet_wrap(~CLARITY, ncol=1) +
      labs(title='Trademark and Patent Applications in Japan') +
      labs(x=paste("INDICATOR_NAME"), y=paste("COUNT_SUM")) +
      layer(data=df(), 
            mapping=aes(x=INDICATOR_NAME, y=COUNT_SUM), 
            stat="identity", 
            stat_params=list(), 
            geom="bar",
            geom_params=list(colour=NA), 
            position=position_identity()
      ) + coord_flip() +
      layer(data=df(), 
            mapping=aes(x=INDICATOR_NAME, y=COUNT_SUM, label=(COUNTRY_NAME)), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", hjust=-0.5), 
            position=position_identity()) 
    plot
  }) 
  
  output$distPlot2 <- renderPlot({             
  
    
    plot <- ggplot(df1(), aes(x=X2004, y=X2013)) + 
      geom_point(shape=1) + labs(title='Patent Applicants from 2004 and 2013') + labs(x=paste("Number of Patent Applicants 2004"), y=paste("Number of Patent Applicants 2013"))
   
    
    
    plot
  }) 
  
  observeEvent(input$clicks3, {
    print(as.numeric(input$clicks3))
  })
  observeEvent(input$clicks, {
    print(as.numeric(input$clicks))
  })
  
})