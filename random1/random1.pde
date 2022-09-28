/** 
using the rejection method 12 from here:
http://extremelearning.com.au/how-to-generate-uniformly-random-points-on-n-spheres-and-n-balls/
shader stuff?
https://github.com/SableRaf/glsltutoP5/blob/master/thndl_tutorial/data/shader.frag
*/
//--------------------------------------------------------
import java.util.*;
import processing.svg.*;
import controlP5.*;
ControlFrame cf;
boolean shouldRepaintColors = false;
import peasy.*;
PeasyCam cam;

int randomPoints = 2000;
int radius = 150;
RandomSphere rs;

float randomModRange = 0.1;
float radiusMaxRatio = 1.5;
float radiusMinRatio = 0.5;



float particleSpeed = 0.1;
long nextEvent = 0;
float xRot = 0.01;
float yRot = 0.00;
float zRot = -0.01;
float pointSize = 1.8;

float[] ambientLightColor = {128, 128, 128};
float[] specularLightColor = {100, 100, 255};
float[] emissivePointColor = {128, 64, 64};
float[] specularPointColor = {64, 64, 200};


boolean randomPointSize = true;

boolean beginExportSVG = false;
boolean exporting = false;

PShader shader1;

void setup()
{
  size(640, 640, P3D);
  shader1 = loadShader("frag.glsl", "vert.glsl");
  smooth();
  cf = new ControlFrame(this, 300, 500, "Controls");

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
  if(!exporting){
    background(0);
  }

  
  ambientLight(ambientLightColor[0],ambientLightColor[1],ambientLightColor[2]);
  lightSpecular(specularLightColor[0],specularLightColor[1],specularLightColor[2]);  
  
  directionalLight(255, 0,  64, 0, 0, -1);
  directionalLight(128, 0,  64, 0, 0, 1);  
  directionalLight(0, 200, 0, 0, -1, 0);
  directionalLight(0, 100, 0, 0, 1, 0);  
  directionalLight(0, 64, 255, -1, 0, 0);
  directionalLight(0, 64, 128, 1, 0, 0);  

  if (beginExportSVG){
    println("begining export");
    exporting = true;
    // P3D needs begin Raw
    beginRaw(SVG, "data/exports/export_"+timestamp()+".svg");
    //beginRecord(SVG, "data/exports/export_"+timestamp()+".svg");
  }
  
  rs.experimentalDraw();

  if (beginExportSVG && exporting){
    println("finished export");
    // P3D needs end Raw
    endRaw();
    //endRecord();
    beginExportSVG = false;
    exporting = false;
  }


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
        if(rs.points[ni].mod < radiusMaxRatio){
          rs.points[ni].mod += rs.points[ni].modDirection * randomMod;          
        } 
        break;
      case IN:
        if(rs.points[ni].mod > radiusMinRatio){
          rs.points[ni].mod += rs.points[ni].modDirection * randomMod;          
        } 
        break;
      case BOUNCE:
        rs.points[ni].mod += rs.points[ni].modDirection * randomMod;
    
        // we've reached the outer mod
        if(rs.points[ni].mod > radiusMaxRatio)
        {
          rs.points[ni].mod = radiusMaxRatio;
          rs.points[ni].modDirection = rs.points[ni].modDirection * -1;
        } 
        // we've reached the inner mod
        else if (rs.points[ni].mod < radiusMinRatio)
        {
          rs.points[ni].mod = radiusMinRatio;
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

void setPointMotionToBounce(){
    for (int ni=0; ni < rs.pointCount; ni++){
      if(rs.points[ni].motionState != MotionState.BOUNCE){
        rs.points[ni].motionState = MotionState.BOUNCE;
      } else {
        rs.points[ni].motionState = MotionState.STILL;
      }
    }
}

void randomizePointSize(){
    for (int ni=0; ni < rs.pointCount; ni++){
      if(randomPointSize){
        rs.points[ni].pointSize = random(1,pointSize);
      } else {
        rs.points[ni].pointSize = pointSize;
      }
    }
}

void setColor(){
  //println(cf.cp5.getAll().get(0));

  emissivePointColor[0] = cf.cp5.getController("emissive color-red").getValue();
  emissivePointColor[1] = cf.cp5.getController("emissive color-green").getValue();
  emissivePointColor[2] = cf.cp5.getController("emissive color-blue").getValue();
  
  specularPointColor[0] = cf.cp5.getController("specular color-red").getValue();
  specularPointColor[1] = cf.cp5.getController("specular color-green").getValue();
  specularPointColor[2] = cf.cp5.getController("specular color-blue").getValue();  

  for (int ni=0; ni < rs.pointCount; ni++){
    rs.points[ni].emissive = emissivePointColor;
    rs.points[ni].specular = specularPointColor;
  }
}

public void exportSVG(){
  beginExportSVG = true;
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
