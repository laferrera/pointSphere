class spherePoint
{
  PVector vector;
  float mod = 1;
  int modDirection = 1;
  float opacity = 1;
  
  spherePoint (float x, float y, float z)
  { 
    vector = new PVector (x,y,z);
    modDirection = random(1) > 0.5 ? 1 : -1;
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
