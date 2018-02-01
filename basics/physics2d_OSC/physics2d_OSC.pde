//TODO Fix SoftBodies Area Influence //<>// //<>//

import netP5.*;  //<>// //<>// //<>//
import oscP5.*;

PShape robot;
float radius_ball = 0;
OscP5 oscP5;
NetAddress myRemoteLocation;


int gameStatus = -1;
int interactionStatus = -1;
float lastX = 0.5;
float lastY = 0.5;
float millisInteraction = 0;
float millisAtPressed = 0;
Boolean bPressedFirstTime = false;
Boolean bCreatingBody = true;
Boolean bChainStarted = false;

///////////////////
int robot_counts = 5;
PShape[] robots = new PShape[robot_counts];


/**
 * 
 * PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
 * 
 * A Processing/Java library for high performance GPU-Computing (GLSL).
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */

import java.util.ArrayList;
import java.util.Arrays;

import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.softbodydynamics.DwPhysics;
import com.thomasdiewald.pixelflow.java.softbodydynamics.constraint.DwSpringConstraint;
import com.thomasdiewald.pixelflow.java.softbodydynamics.constraint.DwSpringConstraint2D;
import com.thomasdiewald.pixelflow.java.softbodydynamics.particle.DwParticle2D;

//SoftBodies
import com.thomasdiewald.pixelflow.java.softbodydynamics.softbody.DwSoftBall2D;
import com.thomasdiewald.pixelflow.java.softbodydynamics.softbody.DwSoftBody2D;
import com.thomasdiewald.pixelflow.java.softbodydynamics.softbody.DwSoftGrid2D;
//Draw Constrains
import com.thomasdiewald.pixelflow.java.utils.DwStrokeStyle;

import processing.core.*;

//
// Getting started with verlet particles/softbody simulation.
// 
// + Collision Detection
//

int viewport_w = 1280;//1280; //2560;
int viewport_h = 720;// 720; //1440
int viewport_x = 0;
int viewport_y = 0;

// physics parameters
DwPhysics.Param param_physics = new DwPhysics.Param();
DwSpringConstraint.Param param_spring_circle   = new DwSpringConstraint.Param();

// physics simulation
DwPhysics<DwParticle2D> physics;

//Modified values
// all we need is an array of particles
int particles_count = 0;
DwParticle2D[] particles = new DwParticle2D[particles_count];


// 0 ... default: particles, spring
// 1 ... tension
int DISPLAY_MODE = 0;


DwSpringConstraint.Param param_spring = new DwSpringConstraint.Param();
DwParticle2D.Param param_particle = new DwParticle2D.Param();

public void settings() {
  size(viewport_w, viewport_h, P2D); 
  smooth(8);
}

public void setup() {

  ///////////////
  //OSC
  oscP5 = new OscP5(this, 12345); // para recibir y enviar
  robot = loadShape("robot.svg");
  
  ///////////////////
  //Array of shapes
  for(int i = 0; i < robots.length; i++){
    robots[i] = loadShape("robot.svg");
  }

  ///////////////  println(numParticlesText);
  surface.setLocation(viewport_x, viewport_y);

  // main library context
  DwPixelFlow context = new DwPixelFlow(this);
  context.print();
  context.printGL();

  // physics object
  physics = new DwPhysics<DwParticle2D>(param_physics);
  // global physics parameters
  param_physics.GRAVITY = new float[]{ 0, 0.0f };
  param_physics.bounds  = new float[]{ 0, 0, width, height };
  param_physics.iterations_collisions = 4;
  param_physics.iterations_springs    = 4;

  frameRate(60);
  ////////////////////
  
  ////Create 5 Objects
  for(int i = 0; i < 5; i++){
    PVector ramdomMiddlePos = new PVector(width*0.5, height*0.5);
    ramdomMiddlePos.x += random(-10f, +10f);
    ramdomMiddlePos.y += random(-10f, +10f);
    float sizeItem= (int)random(10,30);
    addNewItemCollision(2, ramdomMiddlePos.x, ramdomMiddlePos.y, sizeItem, i);
  }

}

//----------------------------------------------
public void drawParticles() {

  // render particles
  shapeMode(CENTER);
  //DwParticle2D[] particles = physics.getParticles();
  for (int i = 0; i < particles_count; i++) {
     fill(0);
    DwParticle2D particle = particles[i]; //<>//
    PShape auxShape = particle.getShape();
    ellipse(particle.cx, particle.cy, particle.rad*2, particle.rad*2);
     fill(255);
   
    shape(auxShape, particle.x(), particle.y(), particle.rad(), particle.rad());
  }
  
//TODO Draw here the equivalent Sprite and the scaled size 


}


//--------------------------------------------
public void update() {
  if (bPressedFirstTime) {
    millisInteraction = millis()*0.001 - millisAtPressed;
  }

  ////////////
  updateMouseInteractions();    

  // update physics simulation
  physics.update(1);
}

//----------------------------------------------
public void draw() {

  update();

  //stats, to the title window
  String txt_fps = String.format(getClass().getName()+ "   [particles %d]   [frame %d]   [fps %6.2f]", particles_count, frameCount, frameRate);
  surface.setTitle(txt_fps);

  // render
  background(150);

  synchronized(physics) {
    drawParticles();
    //drawConstrains();
  }

  ///////
  //OSC
  //My feedBack interaction Character 
  //shapeMode(CENTER);
  //shape(robot, lastX, lastY, 40, 60);
}


//////////////////////////////////////////////////////////////////////////////
// User Interaction
//////////////////////////////////////////////////////////////////////////////

DwParticle2D particle_mouse = null;

public DwParticle2D findNearestParticle(float mx, float my, float search_radius) {
  float dd_min_sq = search_radius * search_radius;
  //DwParticle2D[] particles = physics.getParticles();
  DwParticle2D particle = null;
  for (int i = 0; i < particles_count; i++) {
    float dx = mx - particles[i].cx;
    float dy = my - particles[i].cy;
    float dd_sq =  dx*dx + dy*dy;
    if ( dd_sq < dd_min_sq) {
      dd_min_sq = dd_sq;
      particle = particles[i];
    }
  }
  return particle;
}

//----------------------------------------
public void updateMouseInteractions() {
  if (particle_mouse != null) {
    float[] mouse = {mouseX, mouseY};
    particle_mouse.moveTo(mouse, 0.2f);
  }
}

//---------------------------------------------
public void mousePressed() {

  millisAtPressed = millis()*0.001;
  bPressedFirstTime = true;

  particle_mouse = findNearestParticle(mouseX, mouseY, 50);
  if (particle_mouse != null) {
    particle_mouse.enable(false, false, false);
  } else {
    interactionStatus = 0;
    addSimulatedAction();
    bCreatingBody = true;
  }
}

//-----------------------------------------------
public void mouseDragged() {

  if (particle_mouse != null) {
    //println("particle_mouse active");
    if (mouseButton == LEFT  ) particle_mouse.enable(true, true, true );
    if (mouseButton == CENTER) particle_mouse.enable(true, false, false);
  } else {

    interactionStatus = 1;
    bCreatingBody = true;
    addSimulatedAction();
  }
}
//-----------------------------------------------
public void mouseReleased() {
  if (particle_mouse != null) {
    if (mouseButton == LEFT  ) particle_mouse.enable(true, true, true );
    if (mouseButton == CENTER) particle_mouse.enable(true, false, false);

    particle_mouse = null;
  } else {
    interactionStatus = 2;
    bCreatingBody = false;
    addSimulatedAction();
  }

  bPressedFirstTime = false;
}

//--------------------------------------------
public void keyReleased() {
  if (key == 'r') reset();
  if (key == '1') gameStatus = 1;
  if (key == '2') gameStatus = 2;
  if (key == '3') gameStatus = 3;
  if (key == '4') gameStatus = 4;

  //if (key == 'p') DISPLAY_PARTICLES = !DISPLAY_PARTICLES;
}

//-----------------------------
public void addSimulatedAction() {

  lastX = mouseX;
  lastY = mouseY;

  updateGameInteractions();
}

////-----------------------------
//public void addSimulatedBallItem() {

//  gameStatus = 2;

//  lastX = mouseX;
//  lastY = mouseY;

//  updateGameInteractions();
//}


//----------------------------------------------
public void reset() {
  particles_count = 0;
  particles = new DwParticle2D[particles_count];
  //particles.clear();

  physics.reset(); //Reset ALL. Better use setParticles with a new size?
}

//----------------------------------------------
public void addNewItemCollision(int typeInteraction, float _px, float _py, float _radius, int _idShape) {

  if (typeInteraction == 2) {
    param_particle.DAMP_BOUNDS          = 0.50f;
    param_particle.DAMP_COLLISION       = 0.09990f;
    param_particle.DAMP_VELOCITY        = 0.9;//0.9999991f; 

    //DwParticle2D[] particles = physics.getParticles();

    //Add one circle to this particle
    //int id_LastNodeToAdd = particles.size()-2;
    int   idx_curr = particles_count;
    float radius_collision_scale = 1.1f;


    //radius_ball = map(millisInteraction, 0, 3, 10, 150);
    radius_ball = _radius;
    float rest_len = radius_ball * 3 * radius_collision_scale;

    float spawn_x = _px;
    float spawn_y = _py;
    spawn_x += random(-0.01f, +0.01f);
    spawn_y += random(-0.01f, +0.01f);

    //DwParticle2D auxParticle = new DwParticle2D(particles.size(), px, py, radius, param_particle); //TODO modify 0,0 to real values... 
    DwParticle2D pa = new DwParticle2D(idx_curr);
    pa.setMass(1);
    pa.setParamByRef(param_particle);
    pa.setPosition(spawn_x, spawn_y);
    pa.setRadius(radius_ball);
    pa.setRadiusCollision(radius_ball * radius_collision_scale);
    pa.setCollisionGroup(idx_curr); // every particle has a different collision-ID

    //Adding the same PShape to all Item
    //pa.setShape(robot);
    
    if(robots.length > _idShape){
      pa.setShape(robots[_idShape]);
    }

    synchronized (particles) {
      //auxParticle.enable(true, true, true);
      addParticleToList(pa);
      println("Adding new particle Collision id ="+str(particles_count)+" at frame "+str(frameCount));
    }
  }
}


// required
// kind of the same what an ArrayList<VerletParticle2D> would do.
public void addParticleToList(DwParticle2D particle) {
  if (particles_count >= particles_count) {
    int new_len = (int) Math.max(2, Math.ceil(particles_count*1.5f) );
    if (particles == null) {
      particles = new DwParticle2D[new_len];
    } else {
      particles = Arrays.copyOf(particles, new_len);
    }
  }
  particles[particles_count++] = particle;
  physics.setParticles(particles, particles_count);
}


class NodeVA extends DwParticle2D {
  // int id0, id1;

  NodeVA(int _id, float _px, float _py, float _radius, DwParticle2D.Param _param_particle) {

    super(_id);
    setPosition(_px, _py);
    setRadius(_radius);
    setParamByRef(_param_particle);
  }

  /*
  NodeVA (int _id0, int _id1) {  
   id0 = _id0; 
   id1 = _id1;
   
   //how to add DwParticle2D params... 
   }*/

  void update() {
  }

  void display() {
  }
}



///////////
//OSC

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  if (theOscMessage.checkAddrPattern("/game") == true) {
    //println("Recibiendo cosas /test");
    if (theOscMessage.checkTypetag("iifff")) {
      gameStatus = theOscMessage.get(0).intValue();
      interactionStatus = theOscMessage.get(1).intValue();
      lastX = theOscMessage.get(2).floatValue();
      lastX = lastX*width;
      lastY = theOscMessage.get(3).floatValue();
      lastY = lastY*height;
      millisInteraction = theOscMessage.get(4).floatValue();
      println(gameStatus, interactionStatus, lastX, lastY, millisInteraction);

      updateGameInteractions();
    }
  }
}

//------------------------------------
public void resetGameStatus() {
  gameStatus = -1;
}

//---------------------------------------
public void updateGameInteractions() {
  
  addNewItemCollision(interactionStatus, lastX, lastY, 50, 0);
  
  //if ( gameStatus > 0 ) {
  //  if ( gameStatus == 1) { //Chain
  //    addNewItemChain(interactionStatus, lastX, lastY, false);
  //  } else if (gameStatus == 2) { // Ball
  //    addNewItemCollision(interactionStatus, lastX, lastY);
  //  } else if (gameStatus == 3) { // solid Chain
  //    addNewItemChain(interactionStatus, lastX, lastY, true);
  //  } else if (gameStatus == 4) { // softbody circle
  //    addNewSoftBodyCircle(interactionStatus, lastX, lastY, true);
  //  }
  //}
}