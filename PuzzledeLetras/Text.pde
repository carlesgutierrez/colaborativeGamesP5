PFont myFont;
int timeScreenX;
int timeScreenY;
int titleScreenX;
int titleScreenY;
final int OFFSET_TEXT_X = 40;
final int OFFSET_TEXT_Y = 40;

void setupText() {
  myFont = createFont("ARCADECLASSIC.TTF", 20);
  initMessagesPos();
  textFont(myFont); 
  textSize(18);
  textAlign(CENTER);
}

void initMessagesPos() {
  //Messages postions reset
  timeScreenX = (widthDesiredScale)/2 + OFFSET_TEXT_X;
  timeScreenY = 15 + OFFSET_TEXT_Y - 1;

  titleScreenX = (widthDesiredScale)/2 + OFFSET_TEXT_X;
  titleScreenY = 30 + OFFSET_TEXT_Y;
}

void drawText() {

  switch(status) {
  case STATUS_INTRO:
    textSize(20);
    text(15-timer.second(), timeScreenX, timeScreenY+2); // TODO check Time to sprite is end
    textSize(12);
    text("Descubre tu Barrio", titleScreenX, titleScreenY);
    break;
  case STATUS_PLAYING:
    if (timer.minute() == 1) {
      //ReStart
    } else {
      textSize(20);
      text(60-timer.second(), timeScreenX, timeScreenY);
    }
    break;
  case STATUS_RESTART:
    if (timer.second() >= 5) {
      //println("Clearing the canvas");
    } else {
      textSize(12);
      //text("Descubre tu Barrio", titleScreenX, titleScreenY);
      String result = imageName; 
      int numChars = result.length();
      text(result.substring(0, numChars-4), titleScreenX, titleScreenY);
    }
    break;
  }
}