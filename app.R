#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(httpuv)
library(downloader)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(yaml)


source("./pages/page_def_home.R", local = T)
source("./R/menugauche.R", local = T)

style <- tags$style(HTML(readLines("www/added_styles.css")) )
UI <- dashboardPage(
  skin = "green",
  dashboardHeader(title="Momacs", titleWidth = 230),
  dashboardSidebar(width = 230, MenuGauche ),
  dashboardBody(
    shinyjs::useShinyjs(),
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.readable.css")) ,
    tags$head(tags$script(src = "message-handler.js")),
    tags$head(style),
    tabItems(
      tabItem(tabName = "Home",         tabHome)
    )
  )
)

server <- function( input, output, session) {
  
  typeValue <- ""
  typeValueSearchMarker <- ""
  
  observeEvent(input$run, {
    
    numb <- toString(as.integer(runif(1, 0, 10^9)))
    
    newdir <<- paste0("./www/images/",numb)
    dir.create(newdir)
    
    
    file.copy(input$file1$datapath, newdir);
    
    newFile <<- paste0("./images/", numb, "/0.jpg")
    
    session$sendCustomMessage(type = 'testmessage',
                              message = newFile)

    
  })
  
  observeEvent(input$delete, {
    print("delete")
    print(newdir)
  
    if(dir.exists(newdir)) {
      unlink(newdir, recursive = TRUE, force = TRUE)
    }
    
    
    
  })
  
  source("./server/opt_home.R", local=TRUE)
  
}

shinyApp(ui = UI, server = server)

