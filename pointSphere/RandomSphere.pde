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
      pushMatrix();
        translate(points[ni].x(), points[ni].y(), points[ni].z());
        noStroke();        
        
        fill(0, 0, 0); 

        emissive(points[ni].emissive[0],points[ni].emissive[1],points[ni].emissive[2]);
        specular(points[ni].specular[0], points[ni].specular[1], points[ni].specular[2]);
        // if(random(1) > 0.5){
        //   emissive(points[ni].emissive[0],points[ni].emissive[1],points[ni].emissive[2]);
        //   specular(points[ni].specular[0], points[ni].specular[1], points[ni].specular[2]);
        // } else {
        //   specular(points[ni].emissive[0],points[ni].emissive[1],points[ni].emissive[2]);
        //   emissive(points[ni].specular[0], points[ni].specular[1], points[ni].specular[2]);
        // }

         
        ambient(127,128,128);
        shininess(100.0); 
        box(points[ni].pointSize);
      popMatrix();
    }
  }
  
  void draw2d(){
    int strokeColor = exporting ? 0 : 255;
    noFill();
    for (int ni=0; ni < pointCount; ni++){
      pushMatrix();
        translate(points[ni].x(), points[ni].y(), points[ni].z());
        stroke(strokeColor);
        circle(0,0,points[ni].pointSize);
      popMatrix();
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
