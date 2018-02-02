PFont myFont;
int timeScreenX;
int timeScreenY;
int countDownScreenX;
int countDownScreenY;
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
  timeScreenY = 15 + OFFSET_TEXT_Y;

  countDownScreenX = (widthDesiredScale)/2 + OFFSET_TEXT_X;
  countDownScreenY = 30 + OFFSET_TEXT_Y;
}

void drawText() {

  switch(status) {
  case STATUS_INTRO:
    text(15-timer.second(), timeScreenX, timeScreenY+2); // TODO check Time to sprite is end
    break;
  case STATUS_PLAYING:
    if (timer.minute() == 1) {
      //ReStart
    } else {
      text(60-timer.second(), timeScreenX, timeScreenY+2);
    }
    break;
  case STATUS_RESTART:
    if (timer.second() >= 5) {
      //println("Clearing the canvas");
    } else {
      //TODO or notTODO .... Draw Text Finish? Name of the project?
    }
    break;
  }
}