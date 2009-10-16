ArrayList brindilles=new ArrayList();
//{new Brindille(100,0,30,0.11),new Brindille(110,0,30,0.1)};
float time=0.0;
float angleForce=0.0;

void setup(){
  size(200,200);
  frameRate(60);
  float posx;
  for(int i=0;i<40;i++){
    brindilles.add(new Brindille(20+5*i,0,30,0.15));
  }
}

void draw(){
  background(255);
  incrementTime();
  angleForce=getAngleForce(time);  
  for(int i=0;i<brindilles.size();i++){
    ((Brindille)brindilles.get(i)).draw(gradientHorizontal(angleForce,20+i*5.0));
  }
}

void incrementTime(){
  time=(time+0.01)%TWO_PI;
}

float getAngleForce(float time){
  return -abs(sin(time))*PI;
}

float gradientHorizontal(float angleForce, float posx){
  return angleForce*(1-(posx-20)/width);
}

class Brindille{
  float x,y;
  // length of the first segment
  float l;
  // angle of the first segment with the ground
  float a;
  // resistance against the wind
  float k;
  
  public Brindille(float x, float y, float l, float k){
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
    for(int i=1;i<4;i++){
      rotate(gradientForce(a,i)-a);
      line(0,0,0,gradientLength(l,i));
      translate(0,gradientLength(l,i));
    }
    popMatrix();
  }
  
  // The gradient along the brindille (weak on the base, strong on the top)
  public float gradientForce(float a, float pos){
    return a*pow(1.1,pos);
  }

  // The gradient of length for each segment of the brindille
  // Longer on the base than on the top  
  public float gradientLength(float l, float pos){
    return l/pos;    
  }
}

