tabHome = fluidPage(
  
  fileInput("file1", "Choose jpg file",
            accept = c(
              ".jpg")
  ),
  
  actionButton("run", "Run",  class="btn btn-success"),
  actionButton("end", "End",  class="btn btn-danger"),
  downloadButton("downloadData", "Download", class="btn btn-primary"),
  
  br(), br(),
  actionButton("clear", "Clear Image", class="btn btn-warning"),
  actionButton("deleteLastElement", "Delete Last Point", class="btn btn-warning"),
  
  br(), br(),
  
  #actionButton("delete", "Delete image on server",  class="btn btn-danger"),
  includeHTML(path = "./www/image.html")
)