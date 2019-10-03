final class ParticleBuilder{


    private final int NUM_TARGETS = 9;
    private Target[] targets;
    public final float PARTICLE_INV_MASS = 0.025f;

    public ParticleBuilder(Target[] targets){
        this.targets = targets;
    }

    Particle createParticle(int currentWave){
        int targetNo = (int)random(0, 8);
        int[] targetCoords = targets[targetNo].getCentroid();
        int startX = (int)random(0,DISPLAY_WIDTH);
        int startY = 0;
        PVector v = new PVector(targetCoords[0] - startX, targetCoords[1] - startY);
        PVector n = v.get();
        n = n.normalize();
        int waveFactor = (int)random(currentWave, currentWave + 10);
        waveFactor = waveFactor / 10;
        n.mult(waveFactor);
        return new Particle(startX, startY, n.x, n.y, PARTICLE_INV_MASS);
    }

    Particle[] splitParticle(int currentWave, int numParticles, int startX, int startY){
        Particle[] splitParticles = new Particle[numParticles];
        for(int i = 0; i < numParticles; i++){
            int targetNo = (int)random(0, 8);
            int[] targetCoords = targets[targetNo].getCentroid();
            PVector v = new PVector(targetCoords[0] - startX, targetCoords[1] - startY);
            PVector n = v.get();
            n = n.normalize();
            int waveFactor = (int)random(currentWave, currentWave + 10);
            waveFactor = waveFactor / 10;
            n.mult(waveFactor);
            splitParticles[i] = new Particle(startX, startY, n.x, n.y, PARTICLE_INV_MASS);
        }
        return splitParticles;
    }

    Particle createSatelliteParticle(int currentWave, int startX, int startY){
        int targetNo = (int)random(0, 8);
        int[] targetCoords = targets[targetNo].getCentroid();
        PVector v = new PVector(targetCoords[0] - startX, targetCoords[1] - startY);
        PVector n = v.get();
        n = n.normalize();
        int waveFactor = (int)random(currentWave, currentWave + 10);
        waveFactor = waveFactor / 10;
        n.mult(waveFactor);
        return new Particle(startX, startY, n.x, n.y, PARTICLE_INV_MASS);

    }
}