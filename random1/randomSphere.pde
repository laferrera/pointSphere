class RandomSphere
{
  int pointCount = 0;
  float radius = 0;
  SpherePoint[] points;
  
  //--------------------------------------------------------
  // create random sphere points
  //--------------------------------------------------------
  RandomSphere (int _pointCount, float _radius)
  { 
    pointCount = _pointCount; 
    radius = _radius;
    points = new SpherePoint[pointCount];
    for (int ni=0; ni < pointCount; ni++)
    points[ni] = randomSpherePoint(radius);
  }
 
  //--------------------------------------------------------
  // draw random sphere points  
  //--------------------------------------------------------
  void draw()
  {  
    for (int ni=0; ni < pointCount; ni++){
      //point (points[ni].vector.x, points[ni].vector.y, points[ni].vector.z);
      point (points[ni].x(), points[ni].y(), points[ni].z());
    }
  }
  
  void experimentalDraw()
  {  
    for (int ni=0; ni < pointCount; ni++){
      //point (points[ni].x, points[ni].y, points[ni].z);
       
      //float randomMod = random(0,randomModRange/24);
      //points[ni].mod += points[ni].modDirection * randomMod;
      //if(points[ni].mod > 1 + randomModRange)
      //{
      //  points[ni].mod = 1 + randomModRange;
      //  points[ni].modDirection = points[ni].modDirection * -1;
      //} else if (points[ni].mod < 1 - randomModRange)
      //{
      //  points[ni].mod = 1 - randomModRange;
      //  points[ni].modDirection = points[ni].modDirection * -1;
      //}

      pushMatrix();
        translate(points[ni].x(), points[ni].y(), points[ni].z());
        //int opactity = 
        fill(0, 51, 102); 
        noStroke();
        emissive(100, 100, 180);
        specular(204, 122, 255);
        shininess(100.0); 
        box(pointSize);
      popMatrix();
      //point (points[ni].x(), points[ni].y(), points[ni].z());
    }
  }

  //--------------------------------------------------------
  // return random sphere point using method of Cook/Neumann
  //--------------------------------------------------------
  SpherePoint randomSpherePoint (float sphereRadius)
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
    //return new PVector 
    //  ( 2*(b*d + a*c) / k 
    //  , 2*(c*d - a*b) / k  
    //  , (a*a + d*d - b*b - c*c) / k);
    return new SpherePoint
          ( 2*(b*d + a*c) / k 
          , 2*(c*d - a*b) / k  
          , (a*a + d*d - b*b - c*c) / k);
      
  }
}
