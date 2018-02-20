observeEvent(input$run, {
  roots = c(wd='/')
  images <- parseFilePaths(roots, session$userData$imageFiles)
  
  #TODO check when multi files
  
  
  
  imagesPath <<- toString(images$datapath)
  imagesName <<- toString(images$name)
  
  #roots = c(wd='/')
  #data <<- parseFilePaths(roots, input$files)

  #print(data)
  
  #print(input$files$datapath);
  
  newFile <- "undefined"
  realPath <- "undefined"
  if(!is.null(images)) {
    
    #TODO check exist
    # numb <- toString(as.integer(runif(1, 0, 10^9)))
    
    # newdir <- paste0("./www/images/",numb)
    
    os <- get_os()
    
    sep <- "/"
    
    if(os == "linux") {
      newdir <- "./www/images/tmp"
      realPath <-  "./images/tmp"
    } else if(os == "osx") {
      newdir <- "images/tmp"
      realPath <-  "images/tmp"
    } else {
      #TODO window
       sep <- "\\"
    }
    
    
    if (!dir.exists(newdir))
      dir.create(newdir)
    
    # file.copy(input$file1$datapath, newdir);
    
    # newFile <- paste0("./images/", numb, "/0.jpg")
    newFile <- paste0(newdir, sep, imagesName)
    realPath <- paste0(realPath, sep, imagesName)
    file.copy(imagesPath, newFile)

  }
  
  session$sendCustomMessage(type = 'run',
                            message = realPath)
})

get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}

observeEvent(input$end, {
  session$sendCustomMessage(type = 'end', message = "")
})

observeEvent(input$delete, {
  print("delete")
  print(newdir)
  
  if(dir.exists(newdir)) {
    unlink(newdir, recursive = TRUE, force = TRUE)
  }
  
})

roots = c(wd='/')
shinyFileChoose(input, 'files', root=roots)

observeEvent(input$files, {

  session$userData$imageFiles <- input$files
  output$filepaths <- renderPrint({parseFilePaths(roots, input$files)})

})

observeEvent(input$endImage, {
  
  
  
  #print(input$endImage$imagePath);
  result <- paste0(input$endImage$imagePath, ".mom");
  
  
 
  os <- get_os()
  
  if(os == "linux") {
    result <- str_replace_all(result, "images", "www/images")
  } else if(os == "osx") {
    result <- str_replace_all(result, "./", "")
  } else {
    #TODO finish for window
  }

  #print(result);
  
  momFile <<- result;
  
  file.create(result);
  

  
  fileConn<-file(result)
  txt <- paste0("Name: ", imagesName, "\n")
  txt <- paste0("Path: ", imagesPath, "\n")
  
  txt = paste0(txt, "#Point2D", "\n")
  

  
  if(input$endImage$indexPoint2D > 0) {
  for (i in 1:input$endImage$indexPoint2D){
    p = input$endImage$arrayPoint2D[[i]]
    txt = paste0(txt, "Point2D - {id:  ", p$id, "; x: ", p$x, "; y:", p$y, "}\n")
  }
}
  
  txt = paste0(txt, "#Segment2D", "\n")
  
  if(input$endImage$indexSegment2D > 0) {
  for (i in 1:input$endImage$indexSegment2D){
    s = input$endImage$arraySegment2D[[i]]
    p1 = s$p1
    p2 = s$p2
    if(i == 1) {
      txt = paste0(txt, "Point2D - {id:  ", p1$id, "; x: ", p1$x, "; y:", p1$y, "}\n")
    }
    txt = paste0(txt, "Point2D - {id:  ", p2$id, "; x: ", p2$x, "; y:", p2$y, "}\n")
  }
  
  for (i in 1:input$endImage$indexSegment2D){
    s = input$endImage$arraySegment2D[[i]]
    txt = paste0(txt, "Segment2D - {id:  ", s$id, "; p1: ", s$p1$id, "; p2:", s$p2$id, "}\n")
  }
    
  }
  
  txt = paste0(txt, "#Curve2D", "\n")
  
  
  if(input$endImage$curve$size > 0) {
  for (i in 1:input$endImage$curve$size){
     p = input$endImage$curve$points[[i]]
     txt = paste0(txt, "Point2D - {id:  ", p$id, "; x: ", p$x, "; y:", p$y, "}\n")
  }
    
  txt = paste0(txt, "#Curve2D_all_points", "\n")
  for(x in input$endImage$curve$allpts) {
    txt = paste0(txt, x, " ")
  }
  
  txt = paste0(txt, "\n")
  
  
  }

  writeLines(txt, fileConn)

  close(fileConn)
  
  shinyjs::enable("downloadData")
  shinyjs::show("downloadData")
  
  
})

output$downloadData <- downloadHandler(
  filename = function() {
    paste0(imagesName, ".mom")
  },
  content = function(f) {
    #write.csv(datasetInput(), file, row.names = FALSE)
    file.copy(momFile, f)
  }
)