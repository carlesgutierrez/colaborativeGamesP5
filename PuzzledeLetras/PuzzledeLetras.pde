int widthDesiredScale = 192;
int heightDesiredScale = 157;
Boolean bBackgroundAlpha = false;
int alphaBk = 200;

int dimW = 24;
int dimH = 15;
int gapX = 8;
int gapY = 8;

PImage img;

PVector currentRect;
PVector dimCurrentRect;

Grid grid = new Grid();

void setup(){
    size(640, 360);

  grid.setup(dimW,dimH,gapX,gapY,40,74);
  
  img = loadImage("moonwalk.jpg");
  
  //Current
  currentRect = new PVector(0, 0);
  dimCurrentRect = new PVector(30, 60);
}

void draw(){
if (bBackgroundAlpha) {
    fill(0, 0, 0, alphaBk);
    rectMode(CORNER);
    rect(0, 0, widthDesiredScale+40, heightDesiredScale+40);
  } else background(0, 0, 0);

  strokeWeight(1);
  stroke(0, 255, 255); //RGB Contour Color. https://processing.org/reference/stroke_.html
  drawFacadeContourInside(); //Facade Contour
  update();
  grid.drawBoxMatrix();
  
  image(img, 0, 0);
  img.mask(grid.getMask());
  stroke(255,0,0);
  noFill();
  rect(currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y);

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
        grid.set(r,c);
      }
    }
  }
}