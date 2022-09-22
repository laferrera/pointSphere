/** 
using the rejection method 12 from here:
http://extremelearning.com.au/how-to-generate-uniformly-random-points-on-n-spheres-and-n-balls/
shader stuff?
https://github.com/SableRaf/glsltutoP5/blob/master/thndl_tutorial/data/shader.frag
*/
//--------------------------------------------------------

import controlP5.*;
ControlFrame cf;
import peasy.*;
PeasyCam cam;

int randomPoints = 2000;
int radius = 150;
RandomSphere rs;

float randomModRange = 0.1;
float radiusMaxRatio = 1.5;
float radiusMinRatio = 0.5;



float particleSpeed = 0.05;
long nextEvent = 0;
float xRot = 0.01;
float yRot = 0.00;
float zRot = -0.01;
float pointSize = 1.0;

PShader shader1;

void setup()
{
  size(512, 512, P3D);
  shader1 = loadShader("frag.glsl", "vert.glsl");
  smooth();
  cf = new ControlFrame(this, 200, 200, "Controls");

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(350);
  cam.setMaximumDistance(800);
  cam.setWheelScale(0.2);
  //cam.setDamping(.5,.5,.5);
  
  rs = new RandomSphere (randomPoints, radius);

}
//--------------------------------------------------------
void draw()
{
  background(0);
  //translate(width*0.5, height*0.5);
  //rotateX (rotX);
  //rotateY (rotY);
  ambientLight(122, 255, 182);
  lightSpecular(224, 0, 204);
  directionalLight(255, 100, 0, 0, 0, -1);
  directionalLight(0, 120, 0, 0, -1, 0);
  directionalLight(0, 120, 255, -1, 0, 0);

  
  rs.experimentalDraw();


  //shader(shader1);

  if (millis() >= nextEvent) {
    
    movePoints();
    float _zRot = sin(millis()/1000) * zRot;
    
    
    if (!mousePressed) {
      cam.rotateX(xRot);
      cam.rotateY(yRot);
      cam.rotateZ(_zRot);
    }
    nextEvent = millis() + 10;
  }
}
//--------------------------------------------------------



void mouseReleased() {
 //rotYInertia =  rotY - prevRotY;
 //rotXInertia =  rotX - prevRotX;
}

void movePoints(){
  for (int ni=0; ni < rs.pointCount; ni++){   
    float randomMod = random(0,randomModRange * particleSpeed);
    
    MotionState motionState = rs.points[ni].motionState;
    switch(motionState) {
      case STILL:
        break;
      case OUT:
        if(rs.points[ni].mod < 1 + randomModRange){
          rs.points[ni].mod += rs.points[ni].modDirection * randomMod;          
        } 
        break;
      case IN:
        if(rs.points[ni].mod > 1 - randomModRange){
          rs.points[ni].mod += rs.points[ni].modDirection * randomMod;          
        } 
        break;
      case BOUNCE:
        rs.points[ni].mod += rs.points[ni].modDirection * randomMod;
    
        // we've reached the outer mod
        if(rs.points[ni].mod > 1 + randomModRange)
        {
          rs.points[ni].mod = 1 + randomModRange;
          rs.points[ni].modDirection = rs.points[ni].modDirection * -1;
        } 
        // we've reached the inner mod
        else if (rs.points[ni].mod < 1 - randomModRange)
        {
          rs.points[ni].mod = 1 - randomModRange;
          rs.points[ni].modDirection = rs.points[ni].modDirection * -1;
        }
        break;
    }
  }
}

void keyPressed(KeyEvent ke){
  myKeyPressed(ke);
}

void setPointMotionToOut( int modulo){
  for (int ni=0; ni < rs.pointCount; ni++){
    if(ni%8 == modulo){
        if(rs.points[ni].motionState == MotionState.OUT){
          rs.points[ni].motionState = MotionState.IN;
          rs.points[ni].modDirection = -1;
        } else {
          rs.points[ni].motionState = MotionState.OUT;
          rs.points[ni].modDirection = 1;
        }
    }
  }
}
