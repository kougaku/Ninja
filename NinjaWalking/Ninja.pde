import saito.objloader.*;

class Ninja {

  // status
  private PVector pos = new PVector(0, 0, 0);      // current position. Ninja stands on the x-z plane, so y keeps 0.
  private PVector pos_dst = new PVector(0, 0, 0);  // destination postion
  private float angleY = 0;                        // This decides direction.
  private float walking_speed = 3;

  // flags
  private boolean isWalking = false;
  private boolean isRotating = false;
  private boolean isMoving = false;

  // constants
  private final float READ_MODEL_SCALE = 100;
  private final int FRAME_WAITING_1 = 0;
  private final int FRAME_WAITING_2 = 6;
  
  // animation
  private ArrayList<OBJModel> models = new ArrayList<OBJModel>();
  private float time = 0;
  private int frame = 0;
  
  // constructor
  public Ninja (PApplet app) {
    for ( int i=0; i<12; i++) {
      OBJModel model = new OBJModel(app, "ninja_walk_"+i+".obj", "relative", TRIANGLES);
      model.scale(READ_MODEL_SCALE);
      models.add(model);
    }
  }

  // draw (with update)
  public void draw() {
    update();
    
    pushStyle();
    pushMatrix();
    translate( pos.x, pos.y, pos.z );
    rotateY(angleY);
    noStroke();
    models.get(frame).draw();
    popMatrix();
    popStyle();
  }

  // update status
  public void update() {

    // update animation frame
    if ( isWalking || isRotating || isMoving || !(frame==FRAME_WAITING_1 || frame==FRAME_WAITING_2) ) {
      float animation_speed = walking_speed/10.0;
      frame = ((int)time) % models.size();
      time += animation_speed;
    }
    
    // update ninja position
    if ( isWalking || isMoving ) {
      pos.x += walking_speed * sin(angleY);
      pos.z += walking_speed * cos(angleY);
      
      if ( isMoving && dist(pos.x, pos.z, pos_dst.x, pos_dst.z) <= walking_speed ) {
        pos.x = pos_dst.x;
        pos.z = pos_dst.z;
        this.stop();
        isMoving = false;
      }
    }
  }

  // rotates ninja
  public void rotate(float rot) {
    isRotating = true;
    angleY += rot;
  }

  // begin walking
  public void walk() {
    isWalking = true;
  }

  // stop the motion
  public void stop () {
    isWalking = false;
    isRotating = false;
  }
  
  // look at specified position
  public void lookAt(PVector point) {
    angleY = atan2( point.x-pos.x, point.z-pos.z );    
  }

  // begin waling to the destination
  public void moveTo(PVector point) {
    pos_dst = new PVector(point.x, point.y, point.z);
    if ( dist(pos_dst.x, pos_dst.z, pos.x, pos.z) < 0.0001 ) return;
    lookAt(pos_dst);
    isMoving = true;
  }

  // set position of the ninja
  public void setPosition(PVector _pos) {
    pos = new PVector(_pos.x, _pos.y, _pos.z);
  }
  
  // get position of the ninja
  public PVector getPosition() {
    return new PVector(pos.x, pos.y, pos.z);
  }

  // change walking speed (also animation speed)
  public void setSpeed(float _speed ) {
    walking_speed = _speed;
  }

  // change scale of the model
  public void scale(float scale_factor) {
    for ( OBJModel model : models ) {
      model.scale(scale_factor);  // mult with current sacle factor
    }
  }
}

