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
      newdir <- "www/images/tmp"      # not sure but I think it should be www/images/tmp
      realPath <-  "images/tmp"
      
      # we need to create the two folders, consecutively
      if (!dir.exists(newdir)){
        dir.create("www/images")
        dir.create("www/images/tmp")
      }
      
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
  } else  {
    session$sendCustomMessage(type = 'new',
                              message = "nothing")
  }
}

#====================================================================================

round3 <- function(x) {
  return(round(x, 3))
}

segmentIsPolygon <- function(size, arraySegments) {
  
  if(size <= 2) {
    return(FALSE)
  }
  
  firstP = arraySegments[[1]]$p1
  lastP = arraySegments[[size]]$p2
  
  if(firstP$id == lastP$id) {
    return(TRUE)
  }
  
  lastlastP = arraySegments[[size-1]]$p2
  
  if(lastlastP$x == lastP$x) {
    if(lastlastP$y == lastP$y) {
      arraySegments[[size]]$p2$x = firstP$x
      arraySegments[[size]]$p2$x = firstP$y
      return(TRUE)
    }
  }
  
  return(FALSE)
}

segmentIsLineString <- function(size, arraySegments) {
  if(size < 1) {
    return(FALSE)
  }
  
  if(size == 1) {
    return(TRUE)
  }
  
  firstP = arraySegments[[1]]$p1
  lastP = arraySegments[[size]]$p2
  lastlastP = arraySegments[[size-1]]$p2

  if(firstP$id != lastP$id) {
    if(lastlastP$x != lastP$x) {
      if(lastlastP$y != lastP$y) {
        return(TRUE)
      }
    }
  }
  
  return(FALSE) 
}

curveIsPolygon <- function(type) {
  return(input$endImage$typeofcurve == "close")
}

curveIsLineString <- function(type) {
  return(input$endImage$typeofcurve == "open")
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
    txt = paste0(txt, '  MultiPoint: [', '\n')
    for (i in 1:input$endImage$indexPoint2D){
      p = input$endImage$arrayPoint2D[[i]]
      if(i < input$endImage$indexPoint2D) {
        txt = paste0(txt, '[', round3(p$x), ', ', round3(p$y), '], ')
      } else {
        txt = paste0(txt, '[', round3(p$x), ', ', round3(p$y), ']\n')
      }
    }
    txt = paste0(txt, '  ]', '\n')
  } else {
    txt = paste0(txt, '  MultiPoint: []', '\n')
  }

    txt = paste0(txt, '  MultiLineString: [', '\n')
  
    sizeS = input$endImage$indexSegment2D
    if(segmentIsLineString(sizeS, input$endImage$arraySegment2D)) {
      txt = paste0(txt, '[\n[')
      
      for (i in 1:sizeS){
        s = input$endImage$arraySegment2D[[i]]
        if(i == 1) {
          txt = paste0(txt, '[', round3(s$p1$x),  ", ", round3(s$p1$y), "]")
        }
        
        txt = paste0(txt,', [', round3(s$p2$x),  ", ", round3(s$p2$y), "]")
      }
      txt = paste0(txt, ']\n]\n')
    }
    
    
      
      if(curveIsLineString(input$endImage$typeofcurve)) {
        sizeC = input$endImage$curve$size
          if(sizeC > 0) {
            if(segmentIsLineString(sizeS, input$endImage$arraySegment2D)) {
            txt = paste0(txt, ',\n[\n[')
            } else {
              txt = paste0(txt, '[\n[')
            }
            for (i in 1:sizeC){
              p = input$endImage$curve$points[[i]]
              if(i == 1) {
                txt = paste0(txt, "[", round3(p$x), ", ", round3(p$y), "]")
              } else {
                txt = paste0(txt, ", [", round3(p$x), ", ", round3(p$y), "]")
              }
              
            }
            txt = paste0(txt, '],\n  [')
            index = 1
            sizeCA = length(input$endImage$curve$allpts)
            position = 1
            for(x in input$endImage$curve$allpts) {
              if(index == 2) {
                if(position == sizeCA) {
                  txt = paste0(txt, round3(x), "]")
                } else {
                  txt = paste0(txt, round3(x), "], ")
                }
                
                index = 0
              } else {
                txt = paste0(txt, "[", round3(x), ", ")
              }
              index = index + 1
              position = position + 1
            }
            txt = paste0(txt, '  ]\n]')
        }
      } else {
        txt = paste0(txt, '\n')
      }
      
    
    txt = paste0(txt, '\n]', '\n')
    
    txt = paste0(txt, '  MultiPolygon: [', '\n')
    
    if(segmentIsPolygon(sizeS, input$endImage$arraySegment2D)) {
      txt = paste0(txt, '[\n[')
      for (i in 1:sizeS){
        s = input$endImage$arraySegment2D[[i]]
        if(i == 1) {
          txt = paste0(txt, '[', round3(s$p1$x),  ", ", round3(s$p1$y), "]")
        }
        
        txt = paste0(txt,', [', round3(s$p2$x),  ", ", round3(s$p2$y), "]")
      }
      txt = paste0(txt, ']]', '\n')
    }
    
    if(curveIsPolygon(input$endImage$typeofcurve)) {
      sizeC = input$endImage$curve$size
      if(sizeC > 0) {
        if(segmentIsPolygon(sizeS, input$endImage$arraySegment2D)) {
          txt = paste0(txt, ',\n[\n[')
        } else {
          txt = paste0(txt, '[\n[')
        }
        for (i in 1:sizeC){
          p = input$endImage$curve$points[[i]]
          if(i == 1) {
            txt = paste0(txt, "[", round3(p$x), ", ", round3(p$y), "]")
          } else {
            txt = paste0(txt, ", [", round3(p$x), ", ", round3(p$y), "]")
          }
          
        }
        txt = paste0(txt, '],\n  [')
        index = 1
        sizeCA = length(input$endImage$curve$allpts)
        position = 1
        for(x in input$endImage$curve$allpts) {
          if(index == 2) {
            if(position == sizeCA) {
              txt = paste0(txt, round3(x), "]")
            } else {
              txt = paste0(txt, round3(x), "], ")
            }
            
            index = 0
          } else {
            txt = paste0(txt, "[", round3(x), ", ")
          }
          index = index + 1
          position = position + 1
        }
        txt = paste0(txt, '  ]\n]')
      }
    } else {
      txt = paste0(txt, '\n')
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
  
  txt <- paste0("#Name ", imagesName, "\n")
  txt <- paste0(txt, "#Path ", imagesPath, "\n")
  
  sizeP = input$endImage$indexPoint2D
  if(sizeP > 0) {
    if(sizeP == 1) {
      txt = paste0(txt, "#Point", "\n")
    } else {
      txt = paste0(txt, "#MultiPoint", "\n")
    }
    for (i in 1:sizeP){
      p = input$endImage$arrayPoint2D[[i]]
      txt = paste0(txt, "", round3(p$x), " ", round3(p$y), "\n")
    }
  }
  
  sizeS = input$endImage$indexSegment2D
  if(sizeS > 0) {
    firstP = input$endImage$arraySegment2D[[1]]$p1
    lastP = input$endImage$arraySegment2D[[sizeS]]$p2
    
    if(firstP$id == lastP$id) {
      txt = paste0(txt, "#Polygon", "\n")
    } else {
      txt = paste0(txt, "#LineString", "\n")
    }
    
    for (i in 1:sizeS){
      s = input$endImage$arraySegment2D[[i]]
      if(i == 1) {
        txt = paste0(txt, round3(s$p1$x),  " ", round3(s$p1$y), "\n")
      }
        
      txt = paste0(txt, round3(s$p2$x),  " ", round3(s$p2$y), "\n")
    }
  }
  
  sizeC = input$endImage$curve$size
  if(sizeC > 0) {
    
    if(input$endImage$typeofcurve == "open") {
      txt = paste0(txt, "#LineString\n")
    } else { #close normaly
      txt = paste0(txt, "#Polygon\n")
    }
    
    #for (i in 1:sizeC){
    #  p = input$endImage$curve$points[[i]]
    #  txt = paste0(txt, "Point2D - {id:  ", p$id, "; x: ", round3(p$x), "; y:", round3(p$y), "}\n")
    #}
    
    index = 1
    for(x in input$endImage$curve$allpts) {
      if(index == 2) {
        txt = paste0(txt, round3(x), "\n")
        index = 0
      } else {
        txt = paste0(txt, round3(x), " ")
      }
      index = index + 1
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