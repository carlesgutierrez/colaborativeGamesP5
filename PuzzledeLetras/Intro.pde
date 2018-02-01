import processing.core.PApplet;

StopWatch sw = new StopWatch(); //?

class Intro {

  public PApplet papplet;

  Intro(PApplet aApplet) {
    this.papplet = aApplet;
  }
  void initLlama() {
    llama.setFrameSequence(0, 77, 0.2f);
  }
  public void setup() {
    llama = new Sprite(this.papplet, "IntroMedialab.png", 7, 11, 0);

    initLlama();

    registerMethod("pre", this.papplet);
  }
  public void draw() {
    pushStyle();
    background(100);
    drawFacadeContourInside();
    llama.setXY(135, 135);

    S4P.drawSprites();
    popStyle();
  }
}