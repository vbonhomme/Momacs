tabHome = fluidPage(
  box(width = 12, 
      shinyFilesButton('files', label='Load images', title='Please select a image files', multiple=TRUE, buttonType = "btn btn-primary"),
      h4("OR"),
      textInput("pathImages", "Path to directory of images:")
  ),
  
  
  box(width = 8, 
      
      includeHTML(path = "./www/image.html")
    
  ),
  
  
  box(width = 4, 
        
        
      
      
      #verbatimTextOutput('filepaths'),
  

  
  #fileInput("file1", "Choose jpg file",
  #          accept = c(
  #            ".jpg")
  #),
  
  br(),
  
  actionButton("run", "Run",  class="btn btn-success"),
  actionButton("saveI", "Save",  class="btn btn-success"), 
  
  selectInput("selectimages", "Chose image:", c()),
  
  actionButton("nextI", "Next",  class="btn btn-success"), 
  actionButton("previousI", "Previous",  class="btn btn-success"),
  actionButton("firstI", "First",  class="btn btn-success"),
  actionButton("lastI", "Last",  class="btn btn-success"),

  #actionButton("end", "End",  class="btn btn-danger"),
  #downloadButton("downloadData", "Download", class="btn btn-primary"),

  br(), br(),
  actionButton("buttonMoveImage", "Start move image", class="btn btn-primary"),
  actionButton("clearImage", "Clear Image", class="btn btn-warning"),
  actionButton("deleteLastElement", "Delete last element", class="btn btn-warning"),
  
  br(), br(),
  
  actionButton("buttonDrawPoint", "Start draw point", class="btn btn-info"),
  actionButton("buttonDrawSegment", "Start draw segment", class="btn btn-info"),
  actionButton("buttonDrawCurve", "Start draw curve", class="btn btn-info"),
  br(), br(),
  
  actionButton("buttonAddPointOnSegment", "Start add point on segment", class="btn btn-info"),
  actionButton("buttonAddPointOnCurve", "Start add point on curve", class="btn btn-info"),
  
  br(), br(),
  
  actionButton("buttonMovePoint", "Start move point", class="btn btn-primary"),
  actionButton("buttonMovePointSegment", "Start move segment", class="btn btn-primary"),
  actionButton("buttonMovePointCurve", "Start move curve", class="btn btn-primary"),
  
  br(), br(),
  
  actionButton("buttonDeletePoint", "Start delete point", class="btn btn-warning"),
  actionButton("buttonDeletePointSegment", "Start delete point and segment", class="btn btn-warning"),
  br(), br(),
  actionButton("buttonDeletePointCurve", "Start delete point and curve", class="btn btn-warning"),
  
  br(), br(),
  
  radioButtons("typeCurve", "Type of curve:", choices = list("Close" = "close", "Open" = "open" ), selected = "close")
  
 
)

  #actionButton("delete", "Delete image on server",  class="btn btn-danger"),
  
)