import processing.core.PApplet;

StopWatch sw = new StopWatch(); //?

class Intro {

    public PApplet papplet;

  Intro(PApplet aApplet){
    this.papplet = aApplet;
  }
  void initLlama() {

    llama.setFrameSequence(0, 77, 0.2f);
    System.out.print(llama.getX() + "   " + llama.getY() + "    ");
    System.out.println(llama.getVelX() + "   " + llama.getVelY());
    // }
    System.out.println();
  }
  public void setup() {
//    size(300, 300);
    llama = new Sprite(this.papplet, "IntroMedialab.png", 7, 11, 0);

    // Create the Llama
    //for (int i = 0; i < NBR_GHOSTS; i++) { //ghost[i]
    //llama = new Sprite(this, "ghost2.png", "ghostmask2.png", 4, 1, 0);
    //llama.setDomain(-100, -60, width + 100, height - 100, Sprite.REBOUND);
    //}
    initLlama();

    registerMethod("pre", this.papplet);
  }
  public void draw() {
    pushStyle();
    background(100);
    drawFacadeContourInside();
    llama.setXY(135, 135);

    S4P.drawSprites();

    //stroke(255,0,0);
    //noFill();
    //rect(40, 74, 192, 125);

    popStyle();
  }
}