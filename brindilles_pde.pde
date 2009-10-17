// Array of twigs
ArrayList twigs=new ArrayList();
// Time
float time=0.0;
// Angle from which an imaginary reference twig would be enforced by the wind.
// All other twigs will be more or less bent at this angle in according to their rigidity.
float angleForce=0.0;

// Sketch parameters
int WIDTH=200;
int HEIGHT=200;
int RATE=60;

// Number of twigs
int QUANTITY=20;
// Space between each twig
int XGAP=8;
// Overhead before the first twig
int XOVERHEAD=20;
// length of the first segment of the twig
float LENGTH_FIRST=20.0;
// Rigidity of the twigs
float RIGIDITY=0.15;
// Number of segments by twig
int QUANTITY_SEGMENTS=6;
// Parameter for the rigidity of the segments along a twig (inside a formula) TODO Reformulate
float GRADIENT_RIGIDITY_ALONG_TWIG=1.1;

void setup(){
  size(WIDTH,HEIGHT);
  frameRate(RATE);
  float posx;
  for(int i=0;i<QUANTITY;i++){
    twigs.add(new Twig(XOVERHEAD+XGAP*i,0,LENGTH_FIRST,RIGIDITY));
  }
}

void draw(){
  background(255);
  incrementTime();
  angleForce=getAngleForce(time);  
  for(int i=0;i<twigs.size();i++){
    ((Twig)twigs.get(i)).draw(gradientHorizontal(angleForce,XOVERHEAD+i*XGAP));
  }
}

void incrementTime(){
  time=(time+0.01)%TWO_PI;
}

float getAngleForce(float time){
  return -abs(sin(time))*PI;
}

// Gradient of the wind along axis x.
float gradientHorizontal(float angleForce, float posx){
  return gradientHorizontal(angleForce,posx,1);
}

float gradientHorizontal(float angleForce, float posx, int style){
  float result;
  switch(style){
    case 1:
      if(posx==width/2){
        result=0;
      } else {
        result=angleForce*(1-abs(width/2-posx)/width)*((posx-width/2)/abs(width/2-posx));
      }
      break;
    case 0: 
    default:
      result=angleForce*(1-(posx-20)/width);
      break;
  }
  return result;
}

class Twig{
  float x,y;
  // length of the first segment
  float l;
  // angle of the first segment with the ground
  float a;
  // resistance against the wind
  float k;

  public Twig(float x, float y, float l, float k){
    this.x=x;
    this.y=y;
    this.l=l;
    this.k=k;
  }

  public void draw(float angleForce){
    a=k*angleForce;

    pushMatrix();
    rotate(PI);
    translate(-width,-height);
    // First segment
    translate(x,y);
    rotate(a);
    line(0,0,0,l);
    translate(0,l);
    // All others
    for(int i=1;i<QUANTITY_SEGMENTS;i++){
      rotate(gradientForce(a,i)-a);
      line(0,0,0,gradientLength(l,i));
      translate(0,gradientLength(l,i));
    }
    popMatrix();
  }

  // The gradient along the twig (weak on the base, strong on the top)
  public float gradientForce(float a, float pos){
    return a*pow(GRADIENT_RIGIDITY_ALONG_TWIG,pos);
  }

  // The gradient of length for each segment of the twig
  // Longer on the base than on the top  
  public float gradientLength(float l, float pos){
    return l/pos;    
  }
}



