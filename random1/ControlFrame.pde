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
    curSliderY += 20;
    return curSliderY;
  }

  public void setup() {
    surface.setLocation(10, 10);
    cp5 = new ControlP5(this);

       
    cp5.addSlider("mod range")
       .plugTo(parent, "randomModRange")
       .setRange(0, 1.0)
       .setValue(0.1)
       .setPosition(20, heightOffset())
       .setSize(100, 10)
       ;
       
    cp5.addSlider("particle speed")
       .plugTo(parent, "particleSpeed")
       .setRange(0.01, 1.0)
       .setValue(0.05)
       .setPosition(20, heightOffset())
       .setSize(100, 10)
       ;       
       
    cp5.addSlider("x Rotation")
       .plugTo(parent, "xRot")
       .setRange(-.05, 0.05)
       .setValue(.01)
       .setPosition(20, heightOffset())
       .setSize(100, 10)
       ;

    cp5.addSlider("y Rotation")
       .plugTo(parent, "yRot")
       .setRange(-.05, 0.05)
       .setValue(0)
       .setPosition(20, heightOffset())
       .setSize(100, 10)
       ;
       
    cp5.addSlider("z Rotation")
       .plugTo(parent, "zRot")
       .setRange(-.05, 0.05)
       .setValue(-0.01)
       .setPosition(20, heightOffset())
       .setSize(100, 10)
       ;
       
    cp5.addSlider("point size")
       .plugTo(parent, "pointSize")
       .setRange(1.0, 2.00)
       .setValue(1.0)
       .setPosition(20, heightOffset())
       .setSize(100, 10)
       ;
       
    //cp5.addToggle("Box?")
    //   .plugTo(parent, "shouldDisplayBox")
    //   .setPosition(20, 70)
    //   .setSize(100, 10)
    //   .setValue(true)
    //   .setMode(ControlP5.SWITCH)
    // ;
     

       
   
    cb = new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_BROADCAST): 
            //shouldRedraw = true;
            //break;
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
