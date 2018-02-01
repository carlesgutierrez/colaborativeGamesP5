
class PuzzleLetras {

  int dimW = 24;
  int dimH = 15;
  int gapX = 8;
  int gapY = 8;

  PImage img;
  PVector currentRect;
  PVector dimCurrentRect;

  Grid grid = new Grid();

  PuzzleLetras() {
  }

  void setup() {
    //  size(640, 360);

    grid.setup(dimW, dimH, gapX, gapY, 40, 74);

    img = loadImage("moonwalk.jpg");

    //Current
    currentRect = new PVector(0, 0);
    dimCurrentRect = new PVector(30, 60);
  }

  void draw() {

    background(0, 0, 0);

    stroke(0, 255, 255); //RGB Contour Color. https://processing.org/reference/stroke_.html
    drawFacadeContourInside(); //Facade Contour
    update();
    grid.drawBoxMatrix();

    image(img, 0, 0);
    img.mask(grid.getMask());
    stroke(255, 0, 0);
    noFill();
    rect(currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y);
  }


  void update() {
    currentRect.set(mouseX, mouseY);

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
            if (rectRect(r*gapX, c*gapY, gapX-1, gapY-1, 
              auxBlob.xPos*dimW, auxBlob.xPos*dimH, auxBlob.wRawBlob*Rscale, auxBlob.hRawBlob*Rscale) == true) {
              //currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y) == true) {
              grid.set(r, c);
            }
          }//for Blobs
        }// synchronized
      }
    }
  }
}