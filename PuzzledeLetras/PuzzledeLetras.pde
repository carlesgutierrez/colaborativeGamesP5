import sprites.*;
import sprites.maths.*;
import sprites.utils.*;

int widthDesiredScale = 192;
int heightDesiredScale = 157;
Boolean bBackgroundAlpha = false;
int alphaBk = 200;

// Number of columns
int dimW = 24;
// Numbers of rows
int dimH = 15;
// Gap between puzzle boxes X
int gapX = 8;
// Gap between puzzle boxes X
int gapY = 8;

// Offset in X of the right corner of the Facade
int offsetX = 40;
// Offset in Y of the right corner of the Facade
int offsetY = 74;

PImage img;

PVector currentRect;
PVector dimCurrentRect;

Intro intro = new Intro(this);
Puzzle puzzle = new Puzzle();
Sprite llama;
int status = 0;
boolean fake = true;

int startTime = millis();
void setup() {
  //size(300, 300);
  fullScreen();
  randomSeed(millis());
  noCursor();

  intro.setup();
  puzzle.setup(dimW, dimH, gapX, gapY, offsetX, offsetY);
  img = loadImage("img07.jpg");

  //Current
  currentRect = new PVector(0, 0);
  dimCurrentRect = new PVector(15, 20);
  puzzle.initFigure();

  setup_clientSensor4Games();
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

  int timeElapsed = millis() - startTime;
  if (timeElapsed > 3000) {
    puzzle.initFigure();
    startTime = millis();
  }

  switch(status) {
  case 0:
    intro.draw();
    break;
  case 1:
    update();
    puzzle.drawFigure();
    puzzle.drawBoxMatrix();

    image(img, offsetX, offsetY);
    img.mask(puzzle.getMask());
    stroke(255, 0, 0);
    noFill();

    if (fake) {  
      rect(currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y);
    } else {
      draw_clientSensor4Games(widthDesiredScale, heightDesiredScale, 0.3, true);
    }
    break;
  case 2:
    status = 0;
    break;
  }
}


void update() {
  if (fake) {
    updateMouse();
  } else {
    updateOSC();
  }
}
void updateMouse() {
  currentRect.set(mouseX, mouseY);

  //Update Current PG white boxes if collide with currentBox
  for (int r=0; r<dimW; r++ ) // rows
  {
    for ( int c = 0; c < dimH; c++ ) // columns per row
    {
      if (puzzle.getFigure(r, c)) {
        if (rectRect(r*gapX+offsetX, c*gapY + offsetY, gapX-1, gapY-1, 
          currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y) == true) {
          puzzle.set(r, c);
        }
      }
    }
  }
}

void updateOSC() {
  float Rscale = 0.2;

  //Update Current PG white boxes if collide with currentBox
  for (int r=0; r<dimW; r++ ) // rows
  {
    for ( int c = 0; c < dimH; c++ ) // columns per row
    {
      // get acces to Blobs
      synchronized (blobs) {
        for (YoloBlob auxBlob : blobs) {
          //auxBlob.displaySpoutRects(dimW, dimH, 0.2);
          if (puzzle.getFigure(r, c)) {
            if (rectRect(r*gapX+offsetX, c*gapY + offsetY, gapX-1, gapY-1, 
              auxBlob.xPos*192 +offsetX, auxBlob.yPos*125 + offsetY, auxBlob.wRawBlob*Rscale, auxBlob.hRawBlob*Rscale) == true) {
              //currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y) == true) {
              puzzle.set(r, c);
            }
          }
        }//for Blobs
      }// synchronized
    }
    println("-----");
  }
}

void keyPressed() {
  if (keyCode=='1') {
    status = 0;
  }
  if (keyCode == '2') {
    status = 1;
  }
  if (keyCode == '3') {
    status = 2;
  }
  if (keyCode == '4') {
    println("Changing fake mode to" + !fake);
    fake = !fake;
  }
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
  //processCollisions();
  //if (nbr_dead == NBR_GHOSTS)
  //  initGhosts();
  S4P.updateSprites(elapsedTime);
}