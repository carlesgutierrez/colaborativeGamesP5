/**
 * Alpha Mask. 
 * 
 * Loads a "mask" for an image to specify the transparency 
 * in different parts of the image. The two images are blended
 * together using the mask() method of PImage. 
 */

PImage img;
PImage imgMask;

PGraphics pgToDraw;

void setup() {
  size(640, 360);
  img = loadImage("moonwalk.jpg");
  imgMask = loadImage("mask.jpg");
  img.mask(imgMask);
  imageMode(CENTER);

  //pg setup
  pgToDraw = createGraphics(width,height);//Idem dims
}

//---------------------------------
void updatePG() {
  pgToDraw.beginDraw();
  pgToDraw.background(0);
  pgToDraw.stroke(255);
  pgToDraw.fill(255);
  pgToDraw.ellipse(mouseX, mouseY, 80, 80);
  pgToDraw.endDraw();
}

void draw() {
  updatePG();

  background(0, 102, 153);
  image(img, width/2, height/2);
  img.mask(pgToDraw);
  //image(pgToDraw, mouseX, mouseY);
  
}