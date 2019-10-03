final class City extends Target{

    private int startX, startY;
    private boolean destroyed = false;
    private int HEIGHT = 75;
    private int WIDTH = 150;

    City(int startX){
        this.startX = startX;
        this.startY = DISPLAY_HEIGHT - HEIGHT;
    }

    void render(){
        if (destroyed){
            fill(255, 0, 0);
        }else{
            fill(255);
        }
        rect(startX, startY, WIDTH, HEIGHT);
    }

    public PVector getCorner(){
        return new PVector(startX, startY);
    }

    public int[] getCentroid(){
        return new int[]{startX + (WIDTH / 2), startY + (HEIGHT / 2)};
    }

    public void destroy(){
        destroyed = true;
    }

    public boolean isDestroyed(){
        return destroyed;
    }

    public int getWidth(){ return WIDTH; }
    public int getHeight() { return HEIGHT; }

    public void restore(){
        destroyed = false;
    }

}