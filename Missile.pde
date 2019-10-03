final class Missile{

    private int x1, y1, x2, y2, x3, y3;

    Missile(int startX, int startY){
        this.x1 = startX;
        this.y1 = startY;
        x2 = startX + 10;
        y2 = startY - 20;
        x3 = startX + 20;
        y3 = startY;
    }

    void render(){
        fill(255,0,0);
        triangle(x1, y1, x2, y2, x3, y3);
    }

}