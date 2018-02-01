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
  size(300, 300);
  rects = new boolean[100][100];
  fill(0);
  noStroke();
  
  //Modif rects values
  for (int r=0; r<dimW; r++ ) // rows
  {
    for ( int c = 0; c < dimH; c++ ) // columns per row
    {
      rects[r][c] = randomBool();
    }
  }
  
  //Modif rects values
  //rects[(int)random(100)][(int)random(100)] = true;
  //rects[(int)random(100)][(int)random(100)] = true;
  //rects[(int)random(100)][(int)random(100)] = true;
  //rects[(int)random(100)][(int)random(100)] = true;
  //rects[(int)random(100)][(int)random(100)] = true;
  
}

void draw ()
{
  background(255); // clear background with white
  for (int r=0; r<dimW; r++ ) // rows
  {
    for ( int c = 0; c < dimH; c++ ) // columns per row
    {
      if ( rects[r][c] == true ) // is it on?
      {
        rect( r*gapX, c*gapY, gapX-1, gapY-1 ); // draw it!
      }
    }
  }
}