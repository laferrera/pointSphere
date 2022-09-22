void myKeyPressed(KeyEvent ke)
{
  key = ke.getKey();
  if (key == 's') save("RandomSpherePoints.png");
  if (key == ' ') rs = new RandomSphere (randomPoints, radius);
  if (key == '0') setPointMotionToOut(0);
  if (key == '1') setPointMotionToOut(1);
  if (key == '2') setPointMotionToOut(2);
  if (key == '3') setPointMotionToOut(3);
  if (key == '4') setPointMotionToOut(4);
  if (key == '5') setPointMotionToOut(5);
  if (key == '6') setPointMotionToOut(6);
  if (key == '7') setPointMotionToOut(7);
  
}
