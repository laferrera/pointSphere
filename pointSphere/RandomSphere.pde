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
    Calendar now = Calendar.getInstance();
    noiseSeed(now.getTimeInMillis());
    pointCount = _pointCount; 
    radius = _radius;
    points = new SpherePoint[pointCount];
    
    //int sphereSurfArea = 2 * TWO_PI * sq(sphereRadius)
    for (int ni=0; ni < pointCount; ni++){
      // we should use best candidate
      //https://bl.ocks.org/mbostock/1893974
      //points[ni] = randomSpherePoint(radius);
      points[ni] = perlinSpherePoint(radius, ni);
      //points[ni] = perlinSpherePoint2(radius, ni);
    }
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
        float lerpPercent = (frameCount % zFrameDivisor) * 1/(float)zFrameDivisor;
        emissive(
          points[ni].emissive[0] * lerp(noise(ni,0,zFrameCount), noise(ni,0,zFrameCount + 1), lerpPercent),
          points[ni].emissive[1] * lerp(noise(0,ni,zFrameCount), noise(0,ni,zFrameCount + 1), lerpPercent),
          points[ni].emissive[2] * lerp(noise(ni,ni,zFrameCount), noise(ni,ni,zFrameCount + 1), lerpPercent)
         );
        specular(
          points[ni].specular[0]  * lerp(noise(ni,0,zFrameCount), noise(ni,0,zFrameCount +1), lerpPercent),
          points[ni].specular[1]  * lerp(noise(0,ni,zFrameCount), noise(0,ni,zFrameCount +1), lerpPercent),
          points[ni].specular[2]  * lerp(noise(ni,ni,zFrameCount), noise(ni,ni,zFrameCount +1), lerpPercent)
        );
         
        ambient(127,128,128);
        shininess(100.0); 
        //box(points[ni].pointSize);
        //box(points[ni].pointSize * audioMod);
        sphereDetail(4);
        sphere(points[ni].pointSize * audioMod);
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
    return new SpherePoint
          ( 2*(b*d + a*c) / k 
          , 2*(c*d - a*b) / k  
          , (a*a + d*d - b*b - c*c) / k);
      
  }
  
  //let's try perlin points
  SpherePoint perlinSpherePoint (float sphereRadius, int ni){
    //look at this siggraph paper...
    //https://cs.nyu.edu/~perlin/noise/

    float a=0, b=0, c=0;
    while(!(a+b+c != 0)){

      //a = noise(ni,0) * 2 - 1;
      //b = noise(0,ni) * 2 - 1;
      //c = noise(ni,ni) * 2 - 1;
      a = noise(ni,0) * 2 - 1;
      b = noise(ni,1) * 2 - 1;
      c = noise(ni,2) * 2 - 1;
      
      
    }
    float normalize = 1/sqrt( sq(a) + sq(b) + sq(c) );

    a = a * normalize * sphereRadius ;
    b = b * normalize * sphereRadius; 
    c = c * normalize * sphereRadius;
    return new SpherePoint(a,b,c);
  }
  
    //let's try perlin points harder.... 
  SpherePoint perlinSpherePoint2 (float sphereRadius, int ni){
    //look at this siggraph paper...
    //https://cs.nyu.edu/~perlin/noise/
    Calendar now = Calendar.getInstance();
    noiseSeed(now.getTimeInMillis());
    
    int colCount =  int(sqrt(pointCount));
    //int colCount = pointCount;
    int curRow = floor(ni/colCount);
    int curCol = ni % colCount;
    float curNoise = 0;
    while(curNoise < 0.5){
      curNoise = noise(curCol, curRow);
      ni++;
      curRow = floor(ni/colCount);
      curCol = ni % colCount;
    }
    println("cur ni", ni);
    println("colCount", colCount);
    println("curRow", curRow);
    println("curCol", curCol);
     
    
    //float phi = float(ni) / sqrt(float(pointCount))  * PI;
    //float theta = float(ni) / sqrt(float(pointCount)) * TWO_PI;
    
    float phi = (PI / float(colCount)) * curRow;
    float theta = (TWO_PI / float(colCount)) * curCol;
    float x = radius * sin(phi) * cos(theta);
    float y = radius * sin(phi) * sin(theta);
    float z = radius * cos(phi);
    return new SpherePoint(x,y,z);
  }
  
}
