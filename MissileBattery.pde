final class MissileBattery extends Target{

    private int posX, posY;
    private int num_missiles;
    private boolean destroyed = false;
    private int radius = 250;
    private boolean isMiddle;

    private float MISSILE_INV_MASS = 0.25f;
    private float upwardsThrust = -2.0f;
    
    MissileBattery(int posX, int posY, boolean isMiddle){
        this.posX = posX;
        this.posY = posY;
        this.num_missiles = 10;
        this.isMiddle = isMiddle;
    }

    void renderBattery(){
        if(destroyed){
            fill(255, 0, 0);
        }else{
            fill(255);
        }
        circle(posX, posY, radius);
        renderMissiles();
    }

    private void renderMissiles(){
        int startX = posX;
        int startY = posY - 80;
        for(int i = 0; i < num_missiles; i++){
            Missile missile = new Missile(startX, startY);
            missile.render();
            if(i == 0){
                startX = startX - 15;
                startY = startY + 25;
            }else if(i == 1){
                startX = startX + 30;
            }else if(i == 2){
                startX = startX - 45;
                startY = startY + 25;
            }else if (i == 3 || i == 4){
                startX = startX + 30;
            }else if(i == 5){
                startX = startX - 75;
                startY = startY + 25;
            }else if(i == 6 || i == 7 || i == 8){
                startX += 30;
            }
        }
    }

    void fire(){
        if(num_missiles > 0 && !destroyed){
            num_missiles--;
            PVector v = new PVector(mouseX - posX, mouseY - posY);
            PVector n = v.copy();
            n = n.normalize();
            if(isMiddle){
                n.mult(2);
            }
            firingMissile = new MissileParticle(posX, posY, n.x, n.y, n.x, n.y, MISSILE_INV_MASS);
            missiles.add(firingMissile);
        }
    }

    public int[] getCentroid(){
        return new int[]{posX, posY};
    }

    public void destroy(){
        destroyed = true;
    }

    public boolean isDestroyed(){
        return destroyed;
    }

    public int getRadius(){ return radius / 2; }

    public void reset(){
        num_missiles = 10;
        destroyed = false;
    }

    public int getNumMissiles(){
        return num_missiles;
    }
}