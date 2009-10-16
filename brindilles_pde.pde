Brindille brindille;
float time=0.0;
float angleForce=0.0;

void setup(){
  size(200,200);
  frameRate(100);
  brindille=new Brindille(100,0,30,0.05);
}

void draw(){
  background(255);
  incrementTime();
  angleForce=getAngleForce(time);
  brindille.draw(angleForce);
}

float incrementTime(){
  return time=(time+0.01)%PI;
}

float getAngleForce(float time){
  return sin(time)*PI;
}

class Brindille{
  float x,y;
  float l;
  float a;
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
    translate(x,y);
    rotate(a);
    line(0,0,0,l);
    for(int i=1;i<4;i++){
      translate(0,l);
      rotate(gradientForce(a,i)-a);
      line(0,0,0,l);
    }
    popMatrix();
  }
  
  public float gradientForce(float a, float t){
    return a*pow(1.2,t);
  }
}

