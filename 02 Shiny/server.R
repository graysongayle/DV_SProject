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
  
  df1 <- eventReactive(input$clicks, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
            "select country_name, indicator_name, avg(X2013) from countries
where country_code = \\\'JPN\\\'
                                                                                group by country_name,  indicator_name
                                                                                having avg(X2013) is not null
                                                                                order by avg(x2013) desc"
                                                                               ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_UTEid', PASS='orcl_UTEid', 
                                                                                                 MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  })
  

  
  output$distPlot1 <- renderPlot({             
    plot <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_continuous() +
      #facet_wrap(~CLARITY, ncol=1) +
      labs(title='Blending 2 Data Sources') +
      labs(x=paste("INDICATOR_NAME"), y=paste("Y")) +
      layer(data=df, 
            mapping=aes(x=INDICATOR_NAME, y=Y), 
            stat="identity", 
            stat_params=list(), 
            geom="bar",
            geom_params=list(colour=NA), 
            position=position_identity()
      ) + coord_flip() +
      layer(data=df, 
            mapping=aes(x=INDICATOR_NAME, y=Y, label=(COUNTRY_NAME)), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", hjust=-0.5), 
            position=position_identity()) 
    plot
  }) 
  
  observeEvent(input$clicks, {
    print(as.numeric(input$clicks))
  })
  
})