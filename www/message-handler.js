Shiny.addCustomMessageHandler("run",
  
  function(path_image) {
  
    console.log(path_image);
    
     if(path_image == "undefined") {
        alert("Please, load image before run");
     } else {
        canvas.started = true;
        drawImage(path_image);
     }
  }
);


Shiny.addCustomMessageHandler("end",
  function(message) {
    
    /*if(!ima2D) {
        alert("Please, load image before run");
    } else {
       Shiny.onInputChange("endImage", ima2D);
    }*/
  }
);