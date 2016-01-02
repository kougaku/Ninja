
// get 3D point corresponding to the 2D screen point
PVector getUnProjectedPointOnFloor(float screen_x, float screen_y, PVector floorPosition, PVector floorDirection) {
  PVector f = floorPosition.get(); // floor postion
  PVector n = floorDirection.get(); // normal vector of the floor
  PVector w = unProject(screen_x, screen_y, -1.0); // screen point in 3D space
  PVector e = getEyePosition(); // eye position

  // calculate intersection point
  f.sub(e);
  w.sub(e);
  w.mult( n.dot(f)/n.dot(w) );
  w.add(e);

  return w;
}

// get eye position in current coordinate system
PVector getEyePosition() {
  PMatrix3D mat = (PMatrix3D)getMatrix();
  mat.invert();
  return new PVector( mat.m03, mat.m13, mat.m23 );
}

// convert window coordinate system into the current coordinate system
PVector unProject(float winX, float winY, float winZ) {
  PMatrix3D mat = getMatrixLocalToWindow();  
  mat.invert();
  
  float[] in = {winX, winY, winZ, 1.0f};
  float[] out = new float[4];
  mat.mult(in, out);  // Do not use PMatrix3D.mult(PVector, PVector)
  
  if (out[3] == 0 ) {
    return null;
  }
  
  PVector result = new PVector(out[0]/out[3], out[1]/out[3], out[2]/out[3]);  
  return result;
}

// get the matrix converting local coordinate system into window coordinate system
PMatrix3D getMatrixLocalToWindow() {
  PMatrix3D projection = ((PGraphics3D)g).projection; // projection matrix
  PMatrix3D modelview = ((PGraphics3D)g).modelview;   // modelview matrix
  
  // viewport matrix
  PMatrix3D viewport = new PMatrix3D();
  viewport.m00 = viewport.m03 = width/2;
  viewport.m11 = -height/2;
  viewport.m13 =  height/2;

  // calculate matrix
  viewport.apply(projection);
  viewport.apply(modelview);
  return viewport;
}

