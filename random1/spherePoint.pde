enum MotionState {
  STILL, BOUNCE, OUT, IN;
}

class SpherePoint
{
  
  PVector vector;
  float mod = 1;
  float opacity = 1;
  MotionState motionState = MotionState.IN;
  int modDirection = 1;
  //int modDirection = motionState == MotionState.IN ? -1 : 1;
  
  SpherePoint (float x, float y, float z)
  { 
    vector = new PVector (x,y,z);
    //modDirection = random(1) > 0.5 ? 1 : -1;
    modDirection = motionState == MotionState.IN ? -1 : 1;
  }
  
  public float x(){
    return vector.x * mod;
  }
  
  public float y(){
    return vector.y * mod;
  }
  
  public float z(){
    return vector.z * mod;
  }
  
}
