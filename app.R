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
library(stringr)
library(shinyFiles)


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
    tags$head(tags$script(src =  "config.js")),
    tags$head(tags$script(src =  "curves.js")),
    tags$head(style),
    tabItems(
      tabItem(tabName = "Home",         tabHome)
    )
  )
)

server <- function( input, output, session) {
  
  typeValue <- ""
  typeValueSearchMarker <- ""
  
  shinyjs::hide("downloadData")
  shinyjs::disable("downloadData")
  
  source("./server/opt_home.R", local=TRUE)
  
}

shinyApp(ui = UI, server = server)

