class spherePoint
{
  PVector vector;
  float mod = 1;
  boolean modDirectionUp = true;
  float opacity = 1;
  
  spherePoint (float x, float y, float z)
  { 
    vector = new PVector (x,y,z);
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
