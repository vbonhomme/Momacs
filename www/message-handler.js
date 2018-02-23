Shiny.addCustomMessageHandler("run",
  
  function(path_image) {
  
    //console.log(path_image);
    
     if(path_image == "undefined" || path_image == "./images/tmp/" || path_image == "images/tmp/") {
        alert("Please, load image before run");
     } else {
       
       var lengthimageslist = document.getElementById("selectimages").length;
       
        canvas.started = true;
        canvas.imagePath = path_image;
        drawImage(path_image);
        
        Shiny.onInputChange("loadI", path_image);
     }
  }
);

Shiny.addCustomMessageHandler("index",

  function(indeximage) {
    $("#indeximagecanvas").html("<b>Images </b>: " + indeximage);
  }
);

Shiny.addCustomMessageHandler("end",
  function(message) {
    
    if(!canvas.started) {
        alert("Please, load image before run");
    } else {
       canvas.typeevent = message;
       Shiny.onInputChange("endImage", canvas);
    }
  }
);

Shiny.addCustomMessageHandler("load",
  function(message) {
    if(canvas.started) {

        canvas.indexPoint2D = 0;
        canvas.arrayPoint2D = [];
        canvas.indexSegment2D = 0;
        canvas.arraySegment2D = [];
        canvas.firstSegment = true;
        canvas.curve.size = 0;
        canvas.curve.points = [];

        canvas.loadCanvas(message);
        canvas.redraw();
    }
  }

);
