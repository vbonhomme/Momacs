tabHome = fluidPage(
  
  fileInput("file1", "Choose jpg file",
            accept = c(
              ".jpg")
  ),
  
  actionButton("run", "Run"),
  
  actionButton("delete", "Delete image on server"),
  includeHTML(path = "./www/image.html")
)