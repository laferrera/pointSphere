class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  CallbackListener cb;
  int curSliderY = 10;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{_name}, this);
  }

  public void settings() {
    size(w, h, P2D);
  }

  private int heightOffset(){
    heightOffset(20);
    return curSliderY;
  }

  private int heightOffset(int offset){
    curSliderY += offset;
    return curSliderY;
  }
  

  public void setup() {
    surface.setLocation(10, 10);
    cp5 = new ControlP5(this);
    int cp5width = 200;
       
    // cp5.addSlider("mod range")
    //    .plugTo(parent, "randomModRange")
    //    .setRange(0, 1.0)
    //    .setValue(0.1)
    //    .setPosition(20, heightOffset())
    //    .setSize(cp5width, 10)
    //    ;
       
    cp5.addSlider("max radius")
       .plugTo(parent, "radiusMaxRatio")
       .setRange(1.0, 1.5)
       .setValue(1.1)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;
       
    cp5.addSlider("min radius")
       .plugTo(parent, "radiusMinRatio")
       .setRange(0.5, 1.0)
       .setValue(0.9)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;
       
    cp5.addSlider("particle speed")
       .plugTo(parent, "particleSpeed")
       .setRange(0.01, 1.0)
       .setValue(0.1)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;       
       
    cp5.addSlider("x Rotation")
       .plugTo(parent, "xRot")
       .setRange(-.05, 0.05)
       .setValue(.01)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;

    cp5.addSlider("y Rotation")
       .plugTo(parent, "yRot")
       .setRange(-.05, 0.05)
       .setValue(0)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;
       
    cp5.addSlider("z Rotation")
       .plugTo(parent, "zRot")
       .setRange(-.05, 0.05)
       .setValue(-0.01)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;
       
    cp5.addSlider("point size")
       .plugTo(parent, "pointSize")
       .setRange(1.0, 3.00)
       .setValue(1.0)
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       ;
       
    cp5.addToggle("randomPointSize")
       .plugTo(parent, "randomPointSize")
       .setPosition(20, heightOffset())
       .setSize(cp5width, 10)
       .setValue(randomPointSize)
       .setMode(ControlP5.SWITCH)
     ;
       
       
    cp5.addColorPicker("emissive color")
       .plugTo(parent, "emissivePointColor")
       .setSize(cp5width, 10)
       .setColorValue(color(emissivePointColor[0],emissivePointColor[1],emissivePointColor[2]))
       .setPosition(20, heightOffset())

       ;
       
    cp5.addColorPicker("specular color")
       .plugTo(parent, "specularLightColor")
       .setColorValue(color(specularPointColor[0],specularPointColor[1],specularPointColor[2]))
       .setPosition(20, heightOffset(80))
       .setSize(cp5width, 10)
       ;

    cp5.addButton("exportSVG")
       .plugTo(parent, "exportSVG")
       .setPosition(20, heightOffset(80))
       .setSize(100,10)
       ;
       
    //cp5.addColorPicker("emissive color")
    //   .setPosition(60, 100)
    //   .plugTo(parent, "emissiveColor")
    //   .setValue(emissiveColor)
    //   .setPosition(20, heightOffset(50))
    //   .setSize(100, 10)
    //   ;
       
    //cp5.addColorPicker("specular color")
    //   .setPosition(60, 100)
    //   .plugTo(parent, "specularColor")
    //   .setValue(specularColor)
    //   .setPosition(20, heightOffset(50))
    //   .setSize(100, 10)
    //   ;
       
    //cp5.addToggle("Box?")
    //   .plugTo(parent, "shouldDisplayBox")
    //   .setPosition(20, 70)
    //   .setSize(100, 10)
    //   .setValue(true)
    //   .setMode(ControlP5.SWITCH)
    // ;
     

       
   
    cb = new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        //println(event.getController().getName());
        //println(event.getController());
        //println(event.getAction());
        switch(event.getAction()) {
          case(ControlP5.ACTION_BROADCAST):

            switch(event.getController().getName()){
              case("randomPointSize"):
                randomizePointSize();
                break;
              case("point size"):
                randomizePointSize();
                break;   
              //case("ambient color"):
              //  setColor();
              //  break;   
            }
            break;
          // case(ControlP5.ACTION_CLICK):
          // case(ControlP5.ACTION_DRAG):          
          // case(ControlP5.ACTION_RELEASE):
          default:
            if(event.getController().getName().contains("color")){
                setColor();
                break;
            }
        }

      }
    };
    
    cp5.addCallback(cb);
       
  }

  void gui() {
    cp5.draw();
  }
  
  void keyPressed(KeyEvent ke){
    myKeyPressed(ke);
    
  }

  void draw() {
    background(190);
  }
}
