
int size = 20;
int radious = 200;
float rad ;
int time=0;
float step =0;

void setup() {
  size(500, 500, P3D);  
  step = PI/15;
  //ortho(-width, width, height, -height,0,1000);
  
}

void draw() {
  //orbitControl();  ?
  rotateY(frameCount/1000);
  rotateX(frameCount/1000);  
  
  beginShape();
  time+=1;
  if(time%4 == 0){
  background(255);
    // tetha 180 y psi 360
    for( float tetha = 0 ; tetha <= PI  ; tetha+=step){     
      for( float psi = 0 ; psi <= 2*PI; psi+=step){
        push();
        rad= map(sin(tetha/2*time),-1,1,radious-10, radious);
        //rad = radious;
        translate(rad*sin(tetha)*cos(psi), rad*sin(tetha)*sin(psi), rad*cos(tetha)); 
        strokeWeight(2); 
        point(0,0);      
        pop();
      }
    }
  }
}
