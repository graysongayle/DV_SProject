#ui.R 

library(shiny)

navbarPage(
  title = "Elements of Visualization",
  tabPanel(title = "Crosstab",
           sidebarPanel(
            
             sliderInput("KPI1", "KPI_Low_Max_value:", 
                         min = 1, max = 4750,  value = 4750),
             sliderInput("KPI2", "KPI_Medium_Max_value:", 
                         min = 4750, max = 5000,  value = 5000),
             textInput(inputId = "title", 
                       label = "Crosstab Title",
                       value = "New Title"),
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
             actionButton(inputId = "clicks3",  label = "Click me")
           ),
           
           mainPanel(plotOutput("distPlot2")
           )        
  )
)
