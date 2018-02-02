Shiny.addCustomMessageHandler("testmessage",
  function(message) {
    

    
    console.log(message);
    
    var ctx = document.getElementById('canvas');
    
    var im = document.getElementById('file1');
    
    console.log(im);
    
    if (ctx.getContext) {
      
    

        ctx = ctx.getContext('2d');
        
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        //Loading of the home test image - img1
        var img1 = new Image();

        //drawing of the test image - img1
        img1.onload = function () {
            //draw background image
            ctx.drawImage(img1, 0, 0);
            //draw a box over the top
            ctx.fillStyle = "rgba(127, 140, 141, 0.2)";
            ctx.fillRect(0, 0, 800, 600);

        };
        
      img1.src = message;
      console.log(img1.height != 0);
    
  }
}
);