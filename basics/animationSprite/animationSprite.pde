import sprites.*;
import sprites.maths.*;
import sprites.utils.*;


//final int NBR_LLAMAS = 2;
//Sprites[] llama = new Sprite[NBR_LLAMAS];
Sprite llama;

StopWatch sw = new StopWatch(); //?

void initLlama() {
  float speed, angle;

  //for (int i = 0; i < NBR_GHOSTS; i++) { //llama[i].
  llama.setXY(random(50, width - 50), random(-20, height - 200));
  angle = ((int)random(0, 4)) * 45 + random(-20, 20);
  speed = random(40, 100);
  llama.setSpeed(speed, angle);
  llama.setAccXY(2, 2);
  llama.setVisible(true);
  llama.setDead(false);
  llama.setFrameSequence(0, 3, 0.2f);
  System.out.print(llama.getX() + "   " + llama.getY() + "    ");
  System.out.println(llama.getVelX() + "   " + llama.getVelY());
  // }
  System.out.println();
}

public void setup() {
  size(700, 500);

  // Create the Llama
  //for (int i = 0; i < NBR_GHOSTS; i++) { //ghost[i]
  llama = new Sprite(this, "llama.png", 6, 1, 0);
  //llama = new Sprite(this, "ghost2.png", "ghostmask2.png", 4, 1, 0);
  llama.setDomain(-100, -60, width + 100, height - 100, Sprite.REBOUND);
  //}
  initLlama();
  
   registerMethod("pre", this);
}

public void draw() {
  background(100);
  llama.setXY(mouseX, mouseY);
  S4P.drawSprites();
}

/*
 * Method provided by Processing and is called every 
 * loop before the draw method. It has to be activated
 * with the following statement in setup() <br>
 * <pre>registerMethod("pre", this);</pre>
 */
public void pre() {
  // Calculate time difference since last call
  float elapsedTime = (float) sw.getElapsedTime();
  //processCollisions();
  //if (nbr_dead == NBR_GHOSTS)
  //  initGhosts();
  S4P.updateSprites(elapsedTime);
}