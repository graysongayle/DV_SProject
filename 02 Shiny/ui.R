#ui.R 

library(shiny)

navbarPage(
  title = "Elements of Visualization",
  tabPanel(title = "Crosstab",
           sidebarPanel(
            
             sliderInput("KPI1", "Min difference between 2005 and 2004", 
                         min = -5000, max = 0,  value = -2500),
             sliderInput("KPI2", "Max difference between 2005 and 2004", 
                         min = 0, max = 10000,  value = 2500),
             textInput(inputId = "title", 
                       label = "Crosstab Title",
                       value = "Trademark Applications of Residents and Non Residents in 2005.  KPI is the difference between 2005 and 2004 values."),
             actionButton(inputId = "clicks2",  label = "Click me")
           ),
           
           mainPanel(plotOutput("distPlot")
           )
  ),
  tabPanel(title = "Barchart",
           sidebarPanel(
             actionButton(inputId = "clicks",  label = "Load bar chart")
           ),
           
           mainPanel(plotOutput("distPlot1")
           )
  ),
  tabPanel(title = "Scatterplot",
           sidebarPanel(
             actionButton(inputId = "clicks3",  label = "Load scatterplot")
           ),
           
           mainPanel(plotOutput("distPlot2")
           )        
  )
)
