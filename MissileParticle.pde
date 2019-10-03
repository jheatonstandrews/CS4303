public class MissileParticle{

    private static final float damping = .995f;
    public int currentExplosionSize = 0;
    private int flashCounter = 0;
    private boolean exploding = false;
    private int targetX, targetY;
    private float invMass;


    public final PVector position, acceleration, velocity;

    MissileParticle(int x, int y, float xVel, float yVel, float xAcc, float yAcc, float invMass){
        position = new PVector(x, y);
        velocity = new PVector(xVel, yVel);
        acceleration = new PVector(xAcc, yAcc);
        targetX = mouseX;
        targetY = mouseY;
        this.invMass = invMass;
    }

    void integrate(PVector gravity){
        PVector gAcceleration = gravity.copy();
        PVector acc = acceleration.copy();
        position.add(velocity);
        velocity.add(gAcceleration);
        acc.mult(invMass);
        velocity.add(acceleration);
        velocity.mult(damping);
    }

    void render(){
        fill(0, 0, 255);
        if(targetReached()){
            if(currentExplosionSize < MISSILE_MAX_EXPLOSION_SIZE){
                if (flashCounter % 2 == 0){ 
                    fill(255, 0, 0);
                }else{
                    fill(255);
                }
                circle(position.x, position.y, currentExplosionSize);
                currentExplosionSize = currentExplosionSize + 2;
                flashCounter++;
            }
        }else {
            rect(position.x, position.y, 5, 10);
        }
    }

    boolean targetReached(){
        return (position.y < targetY);  
    }

}