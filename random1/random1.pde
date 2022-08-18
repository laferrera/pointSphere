/** 
using the rejection method 12 from here:
http://extremelearning.com.au/how-to-generate-uniformly-random-points-on-n-spheres-and-n-balls/
*/
//--------------------------------------------------------

int randomPoints = 2000;
int radius = 150;
float rotX, rotY = 0.0;
randomSphere rs;
//PShader shader1;

//--------------------------------------------------------
void setup()
{
  size(512, 512, P3D);
  smooth();
  stroke(220, 200);
  strokeWeight(2.0);
  rs = new randomSphere (randomPoints, radius); 
}
//--------------------------------------------------------
void draw()
{
  background(0);
  translate(width*0.5, height*0.5);
  rotateX (rotX);
  rotateY (rotY);
  lightSpecular(255, 255, 255);
  directionalLight(204, 204, 204, 0, 0, -1);  
  rs.draw();


  if (mousePressed)
  {
     rotY += (pmouseX - mouseX) * -0.002;
     rotX += (pmouseY - mouseY) * +0.002;
  }
  rotY += 0.002;  
}
//--------------------------------------------------------
void keyPressed()
{
  if (key == 's') save("RandomSpherePoints.png");
  if (key == ' ') rs = new randomSphere (randomPoints, round(width / 2.5));
}
