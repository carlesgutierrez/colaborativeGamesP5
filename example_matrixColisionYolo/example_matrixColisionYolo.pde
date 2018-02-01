/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import processing.awt.PSurfaceAWT;

PFont f;
import java.util.concurrent.CopyOnWriteArrayList;
int widthDesiredScale = 192;
int heightDesiredScale = 157;
float scaleRawSize = 0.3; //TODO find the real relation between VideoCamera dims and Screen Final
Boolean bDrawInfo = false;

Boolean bBackgroundAlpha = false;
int alphaBk = 200;


//Spout
// IMPORT THE SPOUT LIBRARY
import spout.*;
PGraphics pgrSpout; // Canvas to receive a texture
PImage imgSpout; // Image to receive a texture
Spout spout; // DECLARE A SPOUT OBJECT

void setup() {

  size(400,400);
  
  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  smoothCanvas.getFrame().setAlwaysOnTop(true);
  smoothCanvas.getFrame().removeNotify();
  smoothCanvas.getFrame().setUndecorated(true);
  smoothCanvas.getFrame().setLocation(0, 0);//2560
  smoothCanvas.getFrame().addNotify();
  //fullScreen();
  colorMode(HSB, 360, 255, 255);

  frameRate(30);

  // Create the font
  printArray(PFont.list());
  f = createFont("SourceCodePro-Regular.ttf", 24);
  textFont(f);

  setup_clientSensor4Games();
  setup_clientSpout();
}

//------------------------------------
void setup_clientSpout(){
  // Create a canvas or an image to receive the data.
  //pgrSpout = createGraphics(width, height, PConstants.P2D);
  //imgSpout = createImage(width, height, ARGB);
  // CREATE A NEW SPOUT OBJECT
  //spout = new Spout(this);
  //spout.createReceiver("Camera");
}

//-----------------------------------
void updateSpout(){
  
    // OPTION 1: Receive and draw the texture
    //spout.receiveTexture();

    // OPTION 2: Receive into PGraphics texture
    // pgr = spout.receiveTexture(pgr);
    // image(pgr, 0, 0, width, height);

    // OPTION 3: Receive into PImage texture
    // img = spout.receiveTexture(img);
    // image(img, 0, 0, width, height);
    
    // OPTION 4: Receive into PImage pixels
    //imgSpout = spout.receivePixels(imgSpout);
    //image(imgSpout, 0, 0, width, height);
}

//-----------------------------------
void drawSpout(){
  //image(imgSpout, 0, 0, width, height);
}

//-----------------------------------
void draw() {
  
  updateSpout();
  drawSpout();
  
  if (bBackgroundAlpha) {
    fill(0, 0, 0, alphaBk);
    rectMode(CORNER);
    rect(0, 0, widthDesiredScale+40, heightDesiredScale+40);
  } else background(0, 0, 0);

  strokeWeight(1);
  stroke(0, 255, 255); //RGB Contour Color. https://processing.org/reference/stroke_.html
  drawFacadeContourInside(); //Facade Contour

  //Text info
  fill(255);
  text("YoloData Example", 0, height-0.1*height);
  text("FrameRate["+str((int)frameRate)+"]", 0, height-0.05*height);

  pushMatrix();
  translate(40, 40 + 32);
  noFill();
  stroke(0, 255, 255);

  fill(0, 255, 0);
  draw_clientSensor4Games(widthDesiredScale, heightDesiredScale - 32, scaleRawSize, bDrawInfo);
  popMatrix();
}

//-----------------------------------
void drawFacadeContourInside()
{

  //left line
  line(40, 72, 40, 196);

  //bottom
  line(40, 196, 231, 196);

  //right side
  line(231, 72, 231, 196);

  // steps
  //flat left
  line(40, 72, 76, 72);

  //vert
  line(76, 72, 76, 56);

  // hor
  line(76, 56, 112, 56);

  //vert
  line(112, 56, 112, 40);

  //top
  line(112, 40, 159, 40);

  //vert right side
  line(159, 40, 159, 56);

  //hors
  line(160, 56, 195, 56);

  //  vert
  line(195, 56, 195, 72);

  //hor
  line(196, 72, 231, 72);
}

void mousePressed() {
   bDrawInfo = true;
}

void mouseReleased(){
  bDrawInfo = false;
}


void keyPressed() {

  if (keyCode==BACKSPACE)bDrawInfo = !bDrawInfo;
  if (key == 'b' || key == 'B')bBackgroundAlpha = !bBackgroundAlpha;
  if (keyCode == LEFT)alphaBk += 10; 
  if (alphaBk>255) alphaBk = 255;
  if (keyCode == RIGHT)alphaBk -= 10; 
  if (alphaBk<1) alphaBk = 1;
}