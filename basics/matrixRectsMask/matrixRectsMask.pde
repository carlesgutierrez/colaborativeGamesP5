PImage img;

///////////
PVector currentRect;
PVector dimCurrentRect;
PGraphics pgToDraw;
///////////////
boolean[][] rects; // twodimensional array, think rows and columns

boolean randomBool() {
  return random(1) > .5;
}

//8x8 pixs?
int dimW = 25;
int dimH = 15;
int gapX = 10;
int gapY = 10;

void setup ()
{
  size(640, 360);

/////////////
img = loadImage("moonwalk.jpg");

  //////////////////////////////
  rects = new boolean[100][100];
  fill(0);
  noStroke();

  //Modif rects values
  for (int r=0; r<dimW; r++ ) // rows
  {
    for ( int c = 0; c < dimH; c++ ) // columns per row
    {
      rects[r][c] = false;//randomBool();
    }
  }
  ////////////////////////////////

  //pg setup
  pgToDraw = createGraphics(width, height);//Idem dims
  
  //Current
  currentRect = new PVector(0, 0);
  dimCurrentRect = new PVector(30, 60);
}

void update() {
  currentRect.set(mouseX, mouseY);

  //Update Current PG white boxes if collide with currentBox
  for (int r=0; r<dimW; r++ ) // rows
  {
    for ( int c = 0; c < dimH; c++ ) // columns per row
    {
      if(rectRect(r*gapX, c*gapY, gapX-1, gapY-1,
      currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y) == true){
        rects[r][c] = true;
        print("rtue");
        println(r,c);
      }
      //if ( rects[r][c] == true ) // is it on?
      //{
      //  rect( r*gapX, c*gapY, gapX-1, gapY-1 ); // draw it!
      //}
    }
  }
}

//------------------------
void drawBoxMatrix() {
  pgToDraw.beginDraw();
  pgToDraw.background(0);
  for (int r=0; r<dimW; r++ ) // rows
  {
    for ( int c = 0; c < dimH; c++ ) // columns per row
    {
      if ( rects[r][c] == true ) // is it on?
      {
        pgToDraw.fill(255, 255, 255);
        pgToDraw.rect( r*gapX, c*gapY, gapX-1, gapY-1 ); // draw it!
      }
    }
  }
  pgToDraw.endDraw();
}

//---------------------------
void draw ()
{
  update();

  background(255); // clear background with white
  drawBoxMatrix();
  
  image(img, 0, 0);
  img.mask(pgToDraw);
  stroke(255,0,0);
  noFill();
  rect(currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y);
}

// RECTANGLE/RECTANGLE
boolean rectRect(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {

  // are the sides of one rectangle touching the other?

  if (r1x + r1w >= r2x &&    // r1 right edge past r2 left
    r1x <= r2x + r2w &&    // r1 left edge past r2 right
    r1y + r1h >= r2y &&    // r1 top edge past r2 bottom
    r1y <= r2y + r2h) {    // r1 bottom edge past r2 top
    return true;
  }
  return false;
}