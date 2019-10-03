public class Satellite{

    public PVector position, velocity;
    public int satRadius = 50;

    private int dropPosition;

    private boolean dropped = false;

    public Satellite(int startX, int startY, float xVel){
        position = new PVector(startX, startY);
        velocity = new PVector(xVel, 0);
        dropPosition = (int)random(10, DISPLAY_WIDTH);
    }

    public void integrate(){
        position.add(velocity);
    }

    public void render(){
        fill(0, 255, 0);
        circle(position.x, position.y, satRadius);
    }

    public void dropParticle(ArrayList<Particle> particleList, ParticleBuilder builder, int currentWave){
        if(position.x > dropPosition && !dropped){
            Particle drop = builder.createSatelliteParticle(currentWave, (int)position.x, (int)position.y);
            particleList.add(drop);
            dropped = true;
        }
        return;
    }

}