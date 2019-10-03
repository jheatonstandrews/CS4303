public class Particle {
  
  public final PVector position, velocity;

  private float invMass;

  private boolean exploding = false;
  public int currentExplosionSize = 0;
  private int flashCounter = 0;

  private final PVector startPos;


  private static final float damping = .995f;

  private boolean split = false;
  private int ySplitPos = 0;
  
  
  Particle(int x, int y, float xVel, float yVel, float invMass) {
    position = new PVector(x, y);
    startPos = position.copy();
    velocity = new PVector(xVel, yVel) ;
    this.invMass = invMass;
  }
  
  void integrate(PVector gravity) {
    PVector acceleration = gravity.copy();
    position.add(velocity) ;
    velocity.add(acceleration) ;
    velocity.mult(damping);    
  }

  void render(){
    if(exploding){
      if (flashCounter % 2 == 0){ 
        fill(255, 0, 0);
      }else{
        fill(255);
      }
      circle(position.x, position.y, currentExplosionSize);
      currentExplosionSize = currentExplosionSize + 2;
      flashCounter++;
    }else{
      fill(255);
      rect(position.x, position.y, 5, 5);
    }
    
  }

  void explode(){
    exploding = true;
  }

  boolean isExploding(){
    return exploding;
  }

  void willSplit(){
    split = true;
  }

  void setSplitPos(int pos){
    ySplitPos = pos;
  }

  boolean checkSplit(){
    if(split && position.y > ySplitPos){
      split = false;
      return true;
    }else{
      return false;
    }
  }
}
