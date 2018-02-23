observeEvent(input$run, {
  roots = c(wd='/') #TODO change for window
  #images <- parseFilePaths(roots, session$userData$imageFiles)
  
  images <- session$userData$imageFiles
  
  if(!is.null(input$pathImages)) {
    #no in load but in input path
    ff <- list.files(path = input$pathImages)
    
    dbjpg <- ff[grep(".jpg", ff, fixed=T)]
    dbpng <- ff[grep(".png", ff, fixed=T)]
    dbbmp <- ff[grep(".bmp", ff, fixed=T)]
    dbjpeg <- ff[grep(".jpeg", ff, fixed=T)]
    ff <- c(dbjpg, dbpng, dbbmp, dbjpeg)

    ffpath <- NULL 
    
    if(str_sub(input$pathImages, start= -1) != "/") {
      ffpath <- paste0(input$pathImages, "/", ff)
    } else {
      ffpath <- paste0(input$pathImages, ff)
    }
    

    
    session$userData$listimages <- data.frame(name = ff, datapath=ffpath, havemom = logical(length = length(ffpath)))
    
    session$userData$imageFiles <- session$userData$listimages[1,]
    
    updateSelectInput(session, "selectimages", label = "Chose image:", choices = session$userData$listimages$name)
    
  } else {
    images <- session$userData$imageFiles
    gestion_image(images)
  }

})

#====================================================================================

gestion_image <- function(images) {
  
  imagesPath <- toString(images$datapath)
  imagesName <- toString(images$name)

  newFile <- "undefined"
  realPath <- "undefined"
  if(!is.null(images)) {
  
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
    
    newFile <- paste0(newdir, sep, imagesName)
    realPath <- paste0(realPath, sep, imagesName)
    
    
    if(!is.null(session$userData$lastjavascriptimage)) {
        if(file.exists(session$userData$lastjavascriptimage)) {
           file.remove(session$userData$lastjavascriptimage)
        }
    }
    
    #on stocke la nouvelle image
    session$userData$lastjavascriptimage <- newFile
    
    file.copy(imagesPath, newFile)
    
  }
  
  session$sendCustomMessage(type = 'run',
                            message = realPath)

}

#====================================================================================

observeEvent(input$loadI, {
  images <- session$userData$imageFiles
  result2 <- paste0(file_path_sans_ext(images$datapath), ".yml");
  loadYamlFile(result2)
})

#====================================================================================

observeEvent(input$nextI, {
  
  if(!is.null(session$userData$listimages)) {
    
    session$sendCustomMessage(type = 'end', message = "next")

  }

})

#====================================================================================

observeEvent(input$saveI, {
  
  if(!is.null(session$userData$listimages)) {
    
    session$sendCustomMessage(type = 'end', message = "save")
    
  }
  
})

#====================================================================================

observeEvent(input$previousI, {

  if(!is.null(session$userData$listimages)) {
    
    session$sendCustomMessage(type = 'end', message = "previous")
    
  }
  
})

#====================================================================================

observeEvent(input$firstI, {
  
  if(!is.null(session$userData$listimages)) {
    
    session$sendCustomMessage(type = 'end', message = "first")

  }
  
})

#====================================================================================

observeEvent(input$lastI, {
  
  if(!is.null(session$userData$listimages)) {
    
    session$sendCustomMessage(type = 'end', message = "last")
  
  }
  
})

#====================================================================================

observeEvent(input$selectimages, {
  if(!is.null(session$userData$listimages)) {
    session$userData$imageFiles <- session$userData$listimages[grep(input$selectimages, session$userData$listimages$name),]
    
    session$userData$indexImage <- grep(input$selectimages, session$userData$listimages$name)[1]
    
    index <- paste0(session$userData$indexImage, " / ",  length(session$userData$listimages$datapath))
    
    session$sendCustomMessage(type = 'index',
                              message = index)

    images <- session$userData$imageFiles
    gestion_image(images)
  }
})

#====================================================================================

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

#====================================================================================

observeEvent(input$end, {
  session$sendCustomMessage(type = 'end', message = "")
})

#====================================================================================

observeEvent(input$delete, {
  print("delete")
  print(newdir)
  
  if(dir.exists(newdir)) {
    unlink(newdir, recursive = TRUE, force = TRUE)
  }
  
})

#====================================================================================

roots = c(wd='/')
shinyFileChoose(input, 'files', root=roots, filetypes=c("jpeg", "gif", "bmp", "png", "jpg"))

#====================================================================================

observeEvent(input$files, {
  roots = c(wd='/')
  images <- parseFilePaths(roots, input$files)

  session$userData$listimages <- cbind(images)
  session$userData$listimages$havemom <- logical(length = length(images$datapath))
  
  session$userData$indexImage <- 1
  
  index <- paste0(session$userData$indexImage, " / ",  length(images$datapath))
  
  session$sendCustomMessage(type = 'index',
                            message = index)
  
  #on selectionne la première
  session$userData$imageFiles <- session$userData$listimages[1,]
  
  images <- session$userData$imageFiles
  
  updateSelectInput(session, "selectimages", label = "Chose image:", choices = session$userData$listimages$name)
  
 # gestion_image(images)
})

#====================================================================================

loadYamlFile <- function(yaml_file) {
  
  if(file.exists(yaml_file)) {
    
      dataprevious <- yaml.load_file(yaml_file)
    
      session$sendCustomMessage(type = 'load',
                                message = dataprevious)
  }
}

#====================================================================================

saveYamlFile <- function (images, input, result) {
  
  if(file.exists(result)) {
    file.remove(result)
  }
  
  file.create(result);
  
  fileConn<-file(result)
  
  imagesPath <- toString(images$datapath)
  imagesName <- toString(images$name)
  
  txt <- paste0('result:\n')
  
  txt <- paste0(txt, '  name: "', imagesName, '"\n')
  txt <- paste0(txt, '  path: "', imagesPath, '"\n')
  
  
  
  if(input$endImage$indexPoint2D > 0) {
    txt = paste0(txt, '  point2D: [', '\n')
    for (i in 1:input$endImage$indexPoint2D){
      p = input$endImage$arrayPoint2D[[i]]
      if(i < input$endImage$indexPoint2D) {
        txt = paste0(txt, '    ', '{ "id":  ', p$id, ', "x": ', p$x, ', "y": ', p$y, '},\n')
      } else {
        txt = paste0(txt, '    ', '{ "id":  ', p$id, ', "x": ', p$x, ', "y": ', p$y, '}\n')
      }
    }
    txt = paste0(txt, '  ]', '\n')
  } else {
    txt = paste0(txt, '  point2D: []', '\n')
  }
  
  txt = paste0(txt, '  segment2D: ', '\n')

    if(input$endImage$indexSegment2D > 0) {
      txt = paste0(txt, '    points: [', '\n')
      
    for (i in 1:input$endImage$indexSegment2D){
      s = input$endImage$arraySegment2D[[i]]
      p1 = s$p1
      p2 = s$p2
      if(i == 1) {
        txt = paste0(txt, '      ', '{ "id":  ', p1$id, ', "x": ', p1$x, ', "y": ', p1$y, '},\n')
        
      }     
      
      if(i < input$endImage$indexSegment2D) {
        txt = paste0(txt, '      ', '{ "id":  ', p2$id, ', "x": ', p2$x, ', "y": ', p2$y, '},\n')
      } else {
        txt = paste0(txt, '      ', '{ "id":  ', p2$id, ', "x": ', p2$x, ', "y": ', p2$y, '}\n')
      }

    }
    
    txt = paste0(txt, '    ]', '\n')
    
    txt = paste0(txt, '    segments: [', '\n')
    
    for (i in 1:input$endImage$indexSegment2D){
      s = input$endImage$arraySegment2D[[i]]
      if(i < input$endImage$indexSegment2D) {
        txt = paste0(txt, '      ', '{ "id":  ', s$id, ', "p1": ', s$p1$id, ', "p2": ', s$p2$id, '},\n')
      } else {
        txt = paste0(txt, '      ', '{ "id":  ', s$id, ', "p1": ', s$p1$id, ', "p2": ', s$p2$id, '}\n')
      }
    }
    
    txt = paste0(txt, '    ]', '\n')
    
    } else {
      txt = paste0(txt, '    points: []', '\n')
      txt = paste0(txt, '    segments: []', '\n')
      
    }
    
  
  
  txt = paste0(txt, '  curve2D: ', '\n')
  
  
    
    txt = paste0(txt, '    type: "', input$endImage$typeofcurve,'"\n')

    txt = paste0(txt, '    points: [', '\n')
    if(input$endImage$curve$size > 0) {
    for (i in 1:input$endImage$curve$size){
      p = input$endImage$curve$points[[i]]
      if(i < input$endImage$curve$size) {
        txt = paste0(txt, '      ', '{ "id":  ', p$id, ', "x": ', p$x, ', "y": ', p$y, '},\n')
      } else {
        txt = paste0(txt, '      ', '{ "id":  ', p$id, ', "x": ', p$x, ', "y": ', p$y, '}\n')
      }
    }
    
    txt = paste0(txt, '    ]', '\n')
    
    txt = paste0(txt, '    curve2D_all_points: [', '\n')
    
    size_points <- length(input$endImage$curve$allpts)
    
    for(i in 1:size_points) {
      
      if(i < size_points) {
        txt = paste0(txt, input$endImage$curve$allpts[[i]], ", ") 
      } else {
        txt = paste0(txt, input$endImage$curve$allpts[[i]], " ") 
      }
    }
    
    }
    
    txt = paste0(txt, '    ]', '\n')
    
    txt = paste0(txt, "\n")
    
  writeLines(txt, fileConn)
  
  close(fileConn)
}

#====================================================================================

saveMomFile <- function (images, input, result) {
  
  if(file.exists(result)) {
    file.remove(result)
  }
  
  file.create(result);
  
  imagesPath <- toString(images$datapath)
  imagesName <- toString(images$name)
  
  fileConn<-file(result)
  
  txt <- paste0("Name: ", imagesName, "\n")
  txt <- paste0(txt, "Path: ", imagesPath, "\n")
  
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
  
  txt = paste0(txt, "#Curve2D: ", input$endImage$typeofcurve, "\n")
  
  
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
  
}

#====================================================================================

observeEvent(input$endImage, {
  
  size <- length(session$userData$listimages$datapath)
  
  images <- session$userData$imageFiles
  
  result <- paste0(file_path_sans_ext(images$datapath), ".mom");
  
  result2 <- paste0(file_path_sans_ext(images$datapath), ".yml");
  
  saveMomFile(images, input, result)
  
  saveYamlFile(images, input, result2)
  
  if(input$endImage$typeevent == "next") { # event next image 
    
    if(session$userData$indexImage < size) {
      
      session$userData$indexImage <- session$userData$indexImage + 1
      
      session$userData$imageFiles <- session$userData$listimages[session$userData$indexImage,]
      
      
      index <- paste0(session$userData$indexImage, " / ",  length(session$userData$listimages$datapath))
      
      session$sendCustomMessage(type = 'index',
                                message = index)
    
      images <- session$userData$imageFiles
      
      updateSelectInput(session, "selectimages", label = "Chose image:", choices = session$userData$listimages$name, selected = session$userData$imageFiles$name)
      
      
      
      
      
    } 
    
  } else if(input$endImage$typeevent == "previous") {

    if(session$userData$indexImage > 1) {
      
      
      session$userData$indexImage <- session$userData$indexImage - 1
      
      session$userData$imageFiles <- session$userData$listimages[session$userData$indexImage,]
      
      index <- paste0(session$userData$indexImage, " / ",  length(session$userData$listimages$datapath))
      
      session$sendCustomMessage(type = 'index',
                                message = index)
      
      images <- session$userData$imageFiles
      
      updateSelectInput(session, "selectimages", label = "Chose image:", choices = session$userData$listimages$name, selected = session$userData$imageFiles$name)
    
    } 
    
  } else if(input$endImage$typeevent == "first") {
      session$userData$indexImage <- 1
      
      session$userData$imageFiles <- session$userData$listimages[session$userData$indexImage,]
      
      index <- paste0(session$userData$indexImage, " / ",  length(session$userData$listimages$datapath))
      
      session$sendCustomMessage(type = 'index',
                                message = index)
      

      images <- session$userData$imageFiles
      
      updateSelectInput(session, "selectimages", label = "Chose image:", choices = session$userData$listimages$name, selected = session$userData$imageFiles$name)
  
  } else if(input$endImage$typeevent == "last") {
    
        session$userData$indexImage <- length(session$userData$listimages$datapath)
        
        session$userData$imageFiles <- session$userData$listimages[session$userData$indexImage,]
        
        index <- paste0(session$userData$indexImage, " / ",  length(session$userData$listimages$datapath))
        
        session$sendCustomMessage(type = 'index',
                                  message = index)
        

        
        images <- session$userData$imageFiles
        
        updateSelectInput(session, "selectimages", label = "Chose image:", choices = session$userData$listimages$name, selected = session$userData$imageFiles$name)
  }

})

#====================================================================================

output$downloadData <- downloadHandler(
  filename = function() {
    paste0(imagesName, ".mom")
  },
  content = function(f) {
    #write.csv(datasetInput(), file, row.names = FALSE)
    file.copy(momFile, f)
  }
)