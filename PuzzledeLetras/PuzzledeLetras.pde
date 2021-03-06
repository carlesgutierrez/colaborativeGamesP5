import lord_of_galaxy.timing_utils.*;  //<>//

import sprites.*;
import sprites.maths.*;
import sprites.utils.*;

int widthDesiredScale = 192;
int heightDesiredScale = 157;
Boolean bBackgroundAlpha = false;
int alphaBk = 200;

String imageName;

// Number of columns
final int COLUMNS = 24;
// Numbers of rows
final int ROWS = 15;
// Offset in X of the right corner of the Facade
final int OFFSET_X = 40;
// Offset in Y of the right corner of the Facade
final int OFFSET_Y = 74;

final int STATUS_INTRO = 0;
final int STATUS_PLAYING = 1;
final int STATUS_RESTART = 2;

final char KEY_INTRO = '1';
final char KEY_PLAY = '2';
final int KEY_IMAGE_I = 73;     //   'i'
final int KEY_CLEAR_C = 67;     //   'c'
final int KEY_END_GAME_E = 69;  //   'e'
final int KEY_FAKE_F = 70;      //   'f'

// Gap between puzzle boxes X
int gapX = 8;
// Gap between puzzle boxes X
int gapY = 8;

PImage img;

PVector currentRect;
PVector dimCurrentRect;

Intro intro = new Intro(this);
Puzzle puzzle = new Puzzle();
Sprite llama;

int status = STATUS_INTRO;
boolean fake = false;
String images[];

Stopwatch timer;
Stopwatch figureTimer;

void setup() {
  //size(300, 300);
  fullScreen();
  randomSeed(millis());
  noCursor();
  
  //text
  setupText();

  intro.setup();
  puzzle.setup(COLUMNS, ROWS, gapX, gapY, OFFSET_X, OFFSET_Y);

  loadImages();
  initImage();

  //Current
  currentRect = new PVector(0, 0);
  dimCurrentRect = new PVector(15, 20);
  puzzle.initFigure();

  setup_clientSensor4Games();

  timer = new Stopwatch(this);
  timer.start();

  figureTimer = new Stopwatch(this);
  figureTimer.start();
}

void draw() {
  if (bBackgroundAlpha) {
    fill(0, 0, 0, alphaBk);
    rectMode(CORNER);
    rect(0, 0, widthDesiredScale+40, heightDesiredScale+40);
  } else {
    background(0, 0, 0);
  }


  strokeWeight(1);
  stroke(0, 255, 255); //RGB Contour Color. https://processing.org/reference/stroke_.html
  drawFacadeContourInside(); //Facade Contour

  if (figureTimer.second() == 3) {
    puzzle.initFigure();
    figureTimer.restart();
  }

  switch(status) {
  case STATUS_INTRO:
    //TODO Init and restart the intro 'correctly'
    intro.draw();
    if (timer.second() == 15) { // TODO check sprite is end
      status = STATUS_PLAYING;
      timer.restart();
    }
    break;
  case STATUS_PLAYING:
    update();

    if (timer.minute() == 1) {
      println("Filling the image and changing to mode 2");
      puzzle.fill();
      status = STATUS_RESTART;
      timer.restart();
    } else {
      if (fake) {
        puzzle.drawFigure();
        rect(currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y);
      } else {
        draw_clientSensor4Games(widthDesiredScale, heightDesiredScale, 0.3, true);
      }
      drawImage();
    }
    break;
  case STATUS_RESTART:
    if (timer.second() >= 5) {
      println("Clearing the canvas");
      puzzle.clear();
      initImage();
      status = 0;
    } else {
      drawImage();
    }
    break;
  }
  
  //text
  drawText();
}


void keyPressed() {
  switch(keyCode) {
  case KEY_INTRO:
    status = STATUS_INTRO;
    break;
  case  KEY_PLAY: // Start game
    status = STATUS_PLAYING;
    break;
  case  KEY_IMAGE_I: // 'i' change image
    initImage();
    break;
  case  KEY_CLEAR_C: // 'c' clear image
    puzzle.clear();
    break;
  case  KEY_END_GAME_E: // 'e' // End game
    println("Finish game");
    puzzle.fill();
    timer.restart();
    status = STATUS_RESTART;
    break;
  case  KEY_FAKE_F: // 'f' (to toggle fake mode)
    println("Fake mode: " + !fake);
    fake = !fake;
    break;
  }
}

//=============================
//  Helper functions
//=============================

// Update the puzzle
void update() {
  if (fake) {
    updateMouse();
  } else {
    updateOSC();
  }
}

// Update the puzzle based on Mouse movement
void updateMouse() {
  currentRect.set(mouseX, mouseY);

  //Update Current PG white boxes if collide with currentBox
  for (int r=0; r<COLUMNS; r++ ) // rows
  {
    for ( int c = 0; c < ROWS; c++ ) // columns per row
    {
      if (puzzle.getFigure(r, c)) {
        if (rectRect(r*gapX+OFFSET_X, c*gapY + OFFSET_Y, gapX-1, gapY-1, 
          currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y) == true) {
          puzzle.set(r, c);
        }
      }
    }
  }
}

// Update the puzzle based on OSC events
void updateOSC() {
  float Rscale = 0.2;

  //Update Current PG white boxes if collide with currentBox
  for (int r=0; r<COLUMNS; r++ ) // rows
  {
    for ( int c = 0; c < ROWS; c++ ) // columns per row
    {
      // get acces to Blobs
      synchronized (blobs) {
        for (YoloBlob auxBlob : blobs) {
          //auxBlob.displaySpoutRects(COLUMNS, ROWS, 0.2);
          //if (puzzle.getFigure(r, c)) {
          if (rectRect(r*gapX+OFFSET_X, c*gapY + OFFSET_Y, gapX-1, gapY-1, 
            auxBlob.xPos*192 +OFFSET_X, auxBlob.yPos*125 + OFFSET_Y, auxBlob.wRawBlob*Rscale, auxBlob.hRawBlob*Rscale) == true) {
            //currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y) == true) {
            puzzle.set(r, c);
          }
          //}
        }//for Blobs
      }// synchronized
    }
  }
}

// Load all available images from the data directory
// Based on code of Daniel Shiffman (https://www.processing.org/examples/directorylist.html)
void loadImages() {
  String path = sketchPath() + "/data/images" ;
  File file = new File(path);
  if (file.isDirectory()) {
    images = file.list();
  }
}

// Initialize the background image verifying it has the right dimentions
void initImage() {
  imageName = images[(int)random(images.length)];
  img = loadImage("data/images/"+imageName);

  while (img.width!=192 || img.height!=125) {
    imageName = images[(int)random(images.length)];
    img = loadImage("data/images/"+imageName);
  }
}

void drawImage() {
  puzzle.drawBoxMatrix();

  image(img, OFFSET_X, OFFSET_Y);
  img.mask(puzzle.getMask());
  stroke(255, 0, 0);
  noFill();
}
/*
 * Method provided by Processing and is called every
 * loop before the draw method. It has to be activated
 * with the following statement in setup() <br>
 * <pre>registerMethod("pre", this);</pre>
 */
public void pre() {
  // Calculate time difference since last call
  float elapsedTime = (float) sw.getElapsedTime();
  S4P.updateSprites(elapsedTime);
}