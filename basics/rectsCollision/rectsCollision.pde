PVector rect1;
PVector dimRect1;

PVector currentRect;
PVector dimCurrentRect;

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

void setup() {
  size(500, 500);
  currentRect = new PVector(0, 0);
  dimCurrentRect = new PVector(100, 10);

  rect1 = new PVector(0, 0);
  dimRect1 = new PVector(40, 100);
}

void draw() {
  background(120);

  rect1.set(width*0.5, height *0.5);
  currentRect.set(mouseX, mouseY);

  if (rectRect(currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y, rect1.x, rect1.y, dimRect1.x, dimRect1.y)) {
    fill(255, 255, 255);
  } else {
    fill(255, 0, 0);
  }
  rect(rect1.x, rect1.y, dimRect1.x, dimRect1.y);

  fill(0, 0, 255);
  rect(currentRect.x, currentRect.y, dimCurrentRect.x, dimCurrentRect.y);
}