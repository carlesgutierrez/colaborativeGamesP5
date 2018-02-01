class YoloBlob { //<>// //<>//
  float xPos;
  float yPos;
  int id; 
  int time; 
  //float probability;
  float wRawBlob;
  float hRawBlob;
  int statusActionH = 0; //0 is regular, -1 is down, 1 is up
  int statusActionW = 0; //0 is regular, -1 is thin, 1 is thick

  // Constructor
  YoloBlob() {
    xPos = -1;
    yPos = -1;
    id = -1; //Id will be the order received or ID from tracking
    time = -1; //time -1 if not tracking
    wRawBlob = 0;
    hRawBlob = 0;
    //TODO add Action Detected
    statusActionH = 0; //0 is regular, -1 is down, 1 is up
    statusActionW = 0; //0 is regular, -1 is thin, 1 is thick
  }

  // Custom method for updating the variables
  void updateOSC() {
  }

  //------------------------------
  void displayBlobInfo(int w, int h) {
    int deltaX = -40;
    int deltaY = -30; 
    text("["+str(id)+"]"+"("+str(time)+")", xPos*w+deltaX, yPos*h*1+deltaY);
  }
  
  //-------------------------------------------------
  // Custom method for drawing the object
  void displayRandomColorRect(int w, int h, float _scaleRawDims) {

    textAlign(LEFT);
    //Draw Received Blob. Probability = quality person detection.
    int idColor = id*100 % 255;
    //fill(idColor, 255, 255, 200);
    noFill();
    stroke(255, 255, 255, 255);
    noStroke();
    strokeWeight(2);  // Thicker
    if (_scaleRawDims>0) {
      rectMode(CENTER);  // Set rectMode to CENTER
      rect(xPos*w, yPos*h, wRawBlob*_scaleRawDims, hRawBlob*_scaleRawDims);
    } else ellipse(xPos*w, yPos*h, 50, 50);

  }
  
  //-------------------------------------------------------
  void displaySpoutRects(int w, int h, float _scaleRawDims){
        textAlign(LEFT);
    //Draw Received Blob. Probability = quality person detection.
    int idColor = id*100 % 255;
    fill(idColor, 255, 255, 200);
    //stroke(255, 255, 255, 255);
    noStroke();
    strokeWeight(2);  // Thicker
    if (_scaleRawDims>0) {
      rectMode(CENTER);  // Set rectMode to CENTER
      rect(xPos*w, yPos*h, wRawBlob*_scaleRawDims, hRawBlob*_scaleRawDims);
    } else ellipse(xPos*w, yPos*h, 50, 50);
  }
  
  //-------------------------------------------------
  void displayYoloRects(int w, int h, float _scaleRawDims) {

    pushStyle();

    int idColorRed = 0; // Red Hue color
    int idColorCyan = 180; // Cyan Hue color
    int idColor = id*100 % 255; // Using Id to set a Hue color

    noFill();

    //Full Rect detected and tracked
    stroke(idColor, 255, 255, 200);
    strokeWeight(1);
    rectMode(CORNER);  // Set rectMode to CENTER
    rect(xPos*w, yPos*h, wRawBlob*_scaleRawDims, hRawBlob*_scaleRawDims);

    // W Status actions feedback
    strokeWeight(3);  
    //width status
    if (statusActionW < 0)stroke(idColorRed, 255, 255, 200);
    else if (statusActionW > 0)stroke(idColorCyan, 255, 255, 200);
    else {
      strokeWeight(1);  // 
      stroke(idColorCyan, 0, 255, 200);
    }
    line(xPos*w, yPos*h, xPos*w+wRawBlob*_scaleRawDims, yPos*h);

    // H Status actions feedback
    strokeWeight(3);  
    if (statusActionH < 0)stroke(idColorRed, 255, 255, 200);
    else if (statusActionH > 0)stroke(idColorCyan, 255, 255, 200);
    else {
      strokeWeight(1); 
      stroke(idColorCyan, 0, 100, 200);
    }
    line(xPos*w, yPos*h, xPos*w, yPos*h+hRawBlob*_scaleRawDims);
    
    //TODO 
    //Draw Spout here
    popStyle();
  }


  //-------------------------------------------------
  void displayRandomColorCircles(int w, int h, float _scaleRawDims) {
    int idColor = id*100 % 255; // Using Id to set a Hue color
    fill(idColor, 255, 255, 200);
    noStroke();
    strokeWeight(2);  // Thicker
    //Using time to control the size of the circle
    float radioCircle = map(time, 0, 200, 2, h*0.5);

    ellipseMode(CENTER);  // Set rectMode to CENTER
    ellipse(xPos*w, yPos*h, radioCircle, radioCircle);
  }

  //-------------------------------------------------
  void displayActionCircles(int w, int h, float _scaleRawDims){
     
   int idColor = id*100 % 255; // Using Id to set a Hue color
    fill(idColor, 255, 255, 200);
    noStroke();
    strokeWeight(2);  // Thicker
    //Using time to control the size of the circle
    float radioCircle = map(time, 0, 200, 2, h*0.5);

    ellipseMode(CENTER);  // Set rectMode to CENTER
    ellipse(xPos*w, yPos*h, radioCircle, radioCircle);
}

}//YoloBlob end class