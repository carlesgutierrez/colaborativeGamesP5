
class Puzzle {
  boolean[][] rects; // twodimensional array, think rows and columns
  boolean[][] figureMask;
  int[] figures = {
     1, 1, 1, 1, 
      0, 1, 1, 0, 
      0, 1, 1, 0,
      0, 1, 1, 0, 
    
      0, 0, 0, 0, 
      0, 1, 1, 0, 
      0, 1, 1, 0, 
      1, 1, 1, 1, 
    
      1, 1, 1, 1, 
      1, 1, 1, 1, 
      1, 1, 1, 1, 
      1, 1, 1, 1, 
    
      1, 1, 0, 0, 
      1, 1, 0, 0, 
      1, 1, 0, 0, 
      1, 1, 0, 0, 

      0, 0, 1, 1, 
      0, 0, 1, 1, 
      0, 0, 1, 1, 
      0, 0, 1, 1,
    
      0, 0, 0, 0, 
      0, 0, 0, 0, 
      1, 1, 1, 1, 
      1, 1, 1, 1, 
    
      1, 1, 1, 1, 
      1, 1, 1, 1, 
      0, 0, 0, 0, 
      0, 0, 0, 0, 
    
      1, 1, 0, 0, 
      0, 1, 1, 0, 
      0, 1, 1, 0, 
      0, 1, 1, 1,
    
      0, 0, 1, 1, 
      0, 1, 1, 0, 
      0, 1, 1, 0, 
      1, 1, 1, 0, 
    
      1, 1, 0, 0, 
      1, 1, 0, 0, 
      1, 1, 1, 1, 
      1, 1, 1, 1, 

      0, 0, 1, 1, 
      0, 0, 1, 1, 
      1, 1, 1, 1, 
      1, 1, 1, 1, 
  };

  //8x8 pixs?
  int dimW = 24;
  int dimH = 15;
  int gapX = 8;
  int gapY = 8;
  int offsetX = 0;
  int offsetY = 0;
  PGraphics pgToDraw;


  /**
   * Initializes the grid
   * @param int aWidth Number of columns
   * @param int aHeight Number of rows
   */
  void setup(int aWidth, int aHeight, int aGapX, int aGapY, int aOffsetX, int aOffsetY)
  {
    dimW = aWidth;
    dimH = aHeight;
    gapX = aGapX;
    gapY = aGapY;
    offsetX = aOffsetX;
    offsetY = aOffsetY;

    rects = new boolean[dimW][dimH];
    figureMask = new boolean[dimW][dimH];

    //Modif rects values
    for (int r=0; r<dimW; r++ ) {
      for ( int c = 0; c < dimH; c++ ) {
        rects[r][c] = false;
      }
    }
    //pg setup
    pgToDraw = createGraphics(192, 125);//Idem dims
  }

  void drawFigure ()
  {
    for (int r=0; r<dimW; r++ ) {
      for ( int c = 0; c < dimH; c++ ) {
        if ( figureMask[r][c]) { 
          rect( r*gapX + offsetX, c*gapY + offsetY, gapX-1, gapY-1 ); // draw it!
        }
      }
    }
  }

  void initFigureRandom() {
    for (int r=0; r<dimW; r++ ) {
      for ( int c = 0; c < dimH; c++ ) {
        figureMask[r][c] = randomBool();
      }
    }
  }

  void initFigure() {
    int x = (int)random(dimW -4);
    int y = (int)random(dimH -4);
    for (int r=0; r<dimW; r++ ) {
      for ( int c = 0; c < dimH; c++ ) {
        figureMask[r][c] = false;
        if (rects[x][y]) {
          x = (int)random(dimW -4);
          y = (int)random(dimH -4);
        }
      }
    }

    int figureIndex = (int) random(figures.length)/4;
    println(figureIndex);
    for (int r=x,i=0; r<x+4; r++,i++ ) {
      for ( int c = y,j=0; c < y+4; c++,j++ ) {
        if (figures[figureIndex+i+j]==1) {
          figureMask[r][c] = true;
        }
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
        if ( rects[r][c]) // is it on?
        {
          pgToDraw.fill(255, 255, 255);
          pgToDraw.rect( r*gapX, c*gapY, gapX-1, gapY-1 ); // draw it!
        }
      }
    }
    pgToDraw.endDraw();
  }

  void set(int x, int y) {
    rects[x][y]=true;
  }

  boolean get(int x, int y) {
    return rects[x][y];
  }

  boolean getFigure(int x, int y) {
    return figureMask[x][y];
  }

  PGraphics getMask() {
    return pgToDraw;
  }

  boolean randomBool() {
    return random(1) > .5;
  }
}