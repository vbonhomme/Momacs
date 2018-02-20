Shiny.addCustomMessageHandler("run",
  
  function(path_image) {
  
    console.log(path_image);
    
     if(path_image == "undefined" || path_image == "./images/tmp/" || path_image == "images/tmp/") {
        alert("Please, load image before run");
     } else {
        canvas.started = true;
        canvas.imagePath = path_image;
        drawImage(path_image);
     }
  }
);


Shiny.addCustomMessageHandler("end",
  function(message) {
    
    if(!canvas.started) {
        alert("Please, load image before run");
    } else {
       console.log(canvas.imagePath);
       Shiny.onInputChange("endImage", canvas);
    }
  }
);