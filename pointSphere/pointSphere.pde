/** 
using the rejection method 12 from here:
http://extremelearning.com.au/how-to-generate-uniformly-random-points-on-n-spheres-and-n-balls/
shader stuff?
https://github.com/SableRaf/glsltutoP5/blob/master/thndl_tutorial/data/shader.frag
//this is also a good looking blog article on poisson disc sampling
//https://www.jasondavies.com/maps/random-points/
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
float radiusMaxRatio = 1.2;
float radiusMinRatio = 0.8;

float particleSpeed = 0.1;
long nextEvent = 0;
float xRot = 0.01;
float yRot = 0.00;
float zRot = -0.01;
float globalPointSize = 1.8;

float[] ambientLightColor = {128, 128, 128};
float[] specularLightColor = {100, 100, 255};
float[] emissivePointColor = {255, 224, 255};
float[] specularPointColor = {64, 32, 255};


boolean pointSelectionMethod = true;
boolean randomPointSize = false;

boolean beginExportSVG = false;
boolean exporting = false;

int zFrameCount = 0;
int zFrameDivisor = 8;

//import ddf.minim.*;
//import ddf.minim.analysis.*;
//Minim minim;
//AudioInput in;audioModOn
import processing.sound.*;
AudioIn input;
Amplitude loudness;

boolean audioModOn = false;
float lastAudioMod = 1;
float audioMod = 1;
float lerpPercent = 1/float(zFrameDivisor);

PShader starglowstreak;
PShader radialStreak;
PShader tv;

void setup()
{
  size(640, 640, P3D);

  smooth(4);
  cf = new ControlFrame(this, 300, 500, "Controls");

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(350);
  cam.setMaximumDistance(800);
  cam.setWheelScale(0.2);
  //cam.setDamping(.5,.5,.5);

  //print(Sound.list());
  //new Sound(this).inputDevice(7);
  input = new AudioIn(this, 0); 
  input.start();
  loudness = new Amplitude(this);
  loudness.input(input);
  
  rs = new RandomSphere (randomPoints, radius);
  starglowstreak = loadShader("myStarglowstreaks.glsl");
  radialStreak = loadShader("myRadialStreak.glsl");
  tv = loadShader("tv1.glsl");
}
//--------------------------------------------------------
void draw()
{
  if(frameCount % zFrameDivisor == 0){
    zFrameCount++;
    lastAudioMod = audioMod; 
    // get(1) is the first sample in the buffer
    if(audioModOn) audioMod = 1 + loudness.analyze() * 25;
    lerpPercent = (frameCount % zFrameDivisor) * 1/(float)zFrameDivisor;
  }
  background(0);
  
  lerp(lastAudioMod, audioMod, lerpPercent);
  
  
  
  ambientLight(ambientLightColor[0],ambientLightColor[1],ambientLightColor[2]);
  lightSpecular(specularLightColor[0],specularLightColor[1],specularLightColor[2]);  
  
  directionalLight(255, 0,  64, 0, 0, -1);
  directionalLight(128, 0,  64, 0, 0, 1);  
  directionalLight(0, 200, 0, 0, -1, 0);
  directionalLight(0, 100, 0, 0, 1, 0);  
  directionalLight(0, 64, 255, -1, 0, 0);
  directionalLight(0, 64, 128, 1, 0, 0); 
  blendMode(BLEND);  
  rs.experimentalDraw();
  
  if (millis() >= nextEvent) {
    
    movePoints();
    //float _zRot = sin(millis()/1000) * zRot;
    
    
    if (!mousePressed) {
      cam.rotateX(xRot);
      cam.rotateY(yRot);
      cam.rotateZ(zRot);
    }
    nextEvent = millis() + 10;
  }


  starglowstreak.set("time", (float) millis()/1000.0);
  filter(starglowstreak);
  
  radialStreak.set("time", (float) millis()/1000.0);
  filter(radialStreak);
  
  tv.set("time", (float) millis()/1000.0);
  filter(tv);
  
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
        rs.points[ni].pointSize = 1 + (globalPointSize - 1) * noise(ni);
      } else {
        rs.points[ni].pointSize = globalPointSize;
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

public void stopRotationCenterCamera(){
  xRot = 0;
  yRot = 0;
  zRot = 0;
  cam.setRotations(0,0,0);
}

public void exportSVG(){
  exporting = true;
 
  println("begining export");
  clear();
  // P3D needs begin Raw
  //beginRecord(SVG, "data/exports/export_"+timestamp()+".svg");
  beginRaw(SVG, "data/exports/export_"+timestamp()+".svg");
  rs.draw2d();
  //endRecord();
  endRaw();
  println("finished export");  
  exporting = false;
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
