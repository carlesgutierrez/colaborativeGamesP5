/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import processing.awt.PSurfaceAWT;

PFont f;
import java.util.concurrent.CopyOnWriteArrayList;
int widthDesiredScale = 192;
int heightDesiredScale = 125;
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

//////////////////
PuzzleLetras myPuzzle;

/////////////////

void setup() {

  size(640, 360);

  myPuzzle = new PuzzleLetras();
  myPuzzle.setup();

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
void setup_clientSpout() {
  // Create a canvas or an image to receive the data.
  //pgrSpout = createGraphics(width, height, PConstants.P2D);
  //imgSpout = createImage(width, height, ARGB);
  // CREATE A NEW SPOUT OBJECT
  //spout = new Spout(this);
  //spout.createReceiver("Camera");
}

//-----------------------------------
void updateSpout() {

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
void drawSpout() {
  //image(imgSpout, 0, 0, width, height);
}

//-----------------------------------
void draw() {

  //updateSpout();
  //drawSpout();

  //Text info
  fill(255);
  text("YoloData Example", 0, height-0.1*height);
  text("FrameRate["+str((int)frameRate)+"]", 0, height-0.05*height);

  //PUzzle
  myPuzzle.draw();

  pushMatrix();
  translate(40, 40 + 32);
  noFill();
  stroke(0, 255, 255);

  fill(0, 255, 0);
  draw_clientSensor4Games(widthDesiredScale, heightDesiredScale, scaleRawSize, bDrawInfo);
  popMatrix();
}


void mousePressed() {
  bDrawInfo = true;
}

void mouseReleased() {
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