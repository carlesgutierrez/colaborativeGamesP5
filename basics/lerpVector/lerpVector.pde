PVector current;
PVector target;

void setup() {
  size(400, 400);
  current = new PVector(100.0, 100.0);
  target = new PVector(200.0, 100.0);
}

void draw() {  
  
  background(100);
  fill(255, 0, 0);
  ellipse(current.x, current.y, 10, 10);
  fill(0, 255, 0);
  ellipse(target.x, target.y, 10, 10);
}

void mousePressed() {
  current.lerp(target, 1.5);

  PVector resultDir;
  resultDir = PVector.sub(current, target);


  print("resultDir ");
  println(resultDir);
  print("Current ");
  println(current);  // Prints "[ 50.0, 50.0, 0.0 ]"
}

void mouseDragged(){
    //Udpate current
  current.set(mouseX, mouseY);
}