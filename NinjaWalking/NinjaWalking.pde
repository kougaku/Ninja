float rotX = -0.16;
float rotY = -0.55;
PVector dest = new PVector(0, 0, 0);
Ninja ninja;

void setup() {
  size(800, 600, P3D);
  ninja = new Ninja(this);
  ninja.scale(1.0);
  ninja.setSpeed(5);
}

void draw() {
  background(200);

  translate(width/2, height/2, 0);
  rotateX(rotY);
  rotateY(rotX);
  
  // calculate destination
  dest = getUnProjectedPointOnFloor(mouseX, mouseY, new PVector(0,0,0), new PVector(0,-1,0) );

  // light 
  lights();
  ambientLight(255, 255, 255);
  noStroke();
  
  // ninja
  ninja.draw();

  // floor
  fill(255);
  box(1000, 0, 1000);
  
  noLights();
  
  // destination
  pushMatrix();
    translate( dest.x, dest.y, dest.z );  
    noStroke();
    fill(0);
    sphere(5);
  popMatrix();  
}

void mousePressed() {
  if ( mouseButton == LEFT ) {
    ninja.moveTo(dest);
  }
}

void mouseDragged() {
  if ( mouseButton == LEFT ) {
    ninja.moveTo(dest);
  }
  if ( mouseButton == RIGHT ) {
    rotX += (mouseX - pmouseX) * 0.01;
    rotY -= (mouseY - pmouseY) * 0.01;
  }
}

void keyPressed() {
  if ( keyCode == UP ) {
    ninja.walk();
  }
  if ( keyCode == LEFT ) {
    ninja.rotate(radians(15));
  }
  if ( keyCode == RIGHT ) {
    ninja.rotate(radians(-15));
  }
}

void keyReleased() {
  ninja.stop();
}
