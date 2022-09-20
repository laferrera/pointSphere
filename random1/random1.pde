/** 
using the rejection method 12 from here:
http://extremelearning.com.au/how-to-generate-uniformly-random-points-on-n-spheres-and-n-balls/
shader stuff?
https://github.com/SableRaf/glsltutoP5/blob/master/thndl_tutorial/data/shader.frag
*/
//--------------------------------------------------------

//int randomPoints = 2000;
int randomPoints = 2000;
int radius = 150;
float rotX, rotY, prevRotY, prevRotX = 0.0;
float rotYInertia = 0.002;
float rotXInertia = 0.001;
//float rotYFriction = 0.95;
//float rotXFriction = 0.95;
float rotYFriction = 1;
float rotXFriction = 1;
randomSphere rs;
float randomModRange = 0.5;
PShader shader1;
import peasy.*;
PeasyCam cam;

void setup()
{
  size(512, 512, P3D);
  shader1 = loadShader("frag.glsl", "vert.glsl");
  smooth();
  
  //ortho(-width/2,width/2,-height/2,height/2,-200,200);

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(350);
  cam.setMaximumDistance(800);
  //cam.setDamping(.5,.5,.5);
  
  rs = new randomSphere (randomPoints, radius);
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

  //if (mousePressed)
  //{  
  //   prevRotY = rotY;
  //   prevRotX = rotX;
  //   rotY += (pmouseX - mouseX) * -0.002;
  //   rotX += (pmouseY - mouseY) * +0.002;
  //   rotYInertia = 0;
  //   rotXInertia = 0;
  //}

  //rotYInertia = rotYInertia * rotYFriction;
  //rotXInertia = rotXInertia * rotXFriction;
  //rotY += rotYInertia;
  //rotX += rotXInertia;  
}
//--------------------------------------------------------
void keyPressed()
{
  if (key == 's') save("RandomSpherePoints.png");
  if (key == ' ') rs = new randomSphere (randomPoints, radius);
}


void mouseReleased() {
 rotYInertia =  rotY - prevRotY;
 rotXInertia =  rotX - prevRotX;
}
