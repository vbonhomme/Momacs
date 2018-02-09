Shiny.addCustomMessageHandler("run",
  
  function(path_image) {
     if(path_image == "undefined") {
        alert("Please, load image before run");
     } else {
        drawImage(path_image);
     }
  }
);


Shiny.addCustomMessageHandler("end",
  function(message) {
    
    if(!ima2D) {
        alert("Please, load image before run");
    } else {
       Shiny.onInputChange("endImage", ima2D);
    }
  }
);

Shiny.addCustomMessageHandler("clear",
  function(message) {
    
    if(!ima2D) {
        alert("Please, load image before run");
    } else {
        drawImage(ima2D.path);
    }
  }
);

Shiny.addCustomMessageHandler("deleteLastElement",
  function(message) {
    
    if(!ima2D) {
        alert("Please, load image before run");
    } else {
        deleteLastElement();
    }
  }
);

