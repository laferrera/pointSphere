class randomSphere
{
  int maxPoints = 0;
  PVector[] points;
  
  //--------------------------------------------------------
  // create random sphere points
  //--------------------------------------------------------
  randomSphere (int pointCount, float sphereRadius)
  { 
    maxPoints = pointCount; 
    points = new PVector[pointCount];
    for (int ni=0; ni < maxPoints; ni++)
    points[ni] = randomSpherePoint (sphereRadius);
  }
 
  //--------------------------------------------------------
  // draw random sphere points  
  //--------------------------------------------------------
  void draw()
  {  
    for (int ni=0; ni < maxPoints; ni++){
      point (points[ni].x, points[ni].y, points[ni].z);
    }
  }
  
  void experimentalDraw()
  {  
    for (int ni=0; ni < maxPoints; ni++){
      //point (points[ni].x, points[ni].y, points[ni].z);
      stroke(random(50,250), 200);
      //point (points[ni].x, points[ni].y, points[ni].z);
      float randomRange = .01;
      float randomMod = random(-randomRange,randomRange);
      randomMod += 1.0;
      point (points[ni].x*randomMod, points[ni].y*randomMod, points[ni].z*randomMod);
    }
  }

  //--------------------------------------------------------
  // return random sphere point using method of Cook/Neumann
  //--------------------------------------------------------
  PVector randomSpherePoint (float sphereRadius)
  {
    float a=0, b=0, c=0, d=0, k=99;
    while (k >= 1.0) 
    { 
      a = random (-1.0, 1.0);
      b = random (-1.0, 1.0);
      c = random (-1.0, 1.0);
      d = random (-1.0, 1.0);
      k = a*a +b*b +c*c +d*d;
    }
    k = k / sphereRadius;
    // if we want to start with points randomly offset from the surface
    //float randomRadiusModifier = 15.5;
    //k = k / (sphereRadius + random(-randomRadiusModifier,randomRadiusModifier));
    return new PVector 
      ( 2*(b*d + a*c) / k 
      , 2*(c*d - a*b) / k  
      , (a*a + d*d - b*b - c*c) / k);
  }
}

class spherePoint
{
  PVector thisVector;
  float mod = 1;
  boolean modDirectionUp = true;
  float opacity = 1;
  
}
