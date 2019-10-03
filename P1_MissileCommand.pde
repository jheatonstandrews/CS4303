import java.util.Iterator;

int num_particles;

final int MISSILE_MAX_EXPLOSION_SIZE = 100;
final int PARTICLE_MAX_EXPLOSION_SIZE = 50;

ArrayList<Particle> particles;

MissileParticle firingMissile;

ArrayList<MissileParticle> missiles;

MissileBattery leftBattery, middleBattery, rightBattery;

City cityOne, cityTwo, cityThree, cityFour, cityFive, citySix;

boolean firing;

int currentWave;

private Target[] targets;
private MissileBattery[] batteries;
private City[] cities;

ParticleBuilder partBuilder;

PVector gravity = new PVector(0f, 0.01f);

final int DISPLAY_WIDTH = 2000;
final int DISPLAY_HEIGHT = 1200;

boolean gameOver;

int score;

int cityRestorePoints;

Satellite satellite;

int[] splitting;



void setup() {
  size(2000, 1200);
  startGame();
}

void startGame(){
  gameOver = false;
  score = 0;
  cityRestorePoints = 0;
  currentWave = 1;
  firing = false;
  num_particles = 9;
  particles = new ArrayList<Particle>();
  missiles = new ArrayList<MissileParticle>();
  satellite = null;
  leftBattery = new MissileBattery(125, DISPLAY_HEIGHT, false);
  middleBattery = new MissileBattery(DISPLAY_WIDTH / 2, DISPLAY_HEIGHT, true);
  rightBattery = new MissileBattery(DISPLAY_WIDTH - 125, DISPLAY_HEIGHT, false);
  cityOne = new City(300);
  cityTwo = new City(500);
  cityThree = new City(700);
  cityFour = new City((DISPLAY_WIDTH / 2) + 150);
  cityFive = new City((DISPLAY_WIDTH / 2) + 350);
  citySix = new City((DISPLAY_WIDTH / 2) + 550);
  targets = new Target[]{leftBattery, middleBattery, rightBattery, cityOne,
      cityTwo, cityThree, cityFour, cityFive, citySix};  
  cities = new City[]{cityOne, cityTwo, cityThree, cityFour, cityFive, citySix};
  batteries = new MissileBattery[]{leftBattery, middleBattery, rightBattery};
  partBuilder = new ParticleBuilder(targets);
  for (int i = 0; i < num_particles; i++){ 
    Particle newParticle = partBuilder.createParticle(currentWave);
    particles.add(newParticle);
  }
}




void draw() {
  if(!gameOver){
  background(0) ;
  fill(255, 255, 255);
  textSize(50);
  text("Score: " + score, 0, 50);
  text("Wave: " + currentWave, 0, 100);
  for(int j = 0; j < particles.size(); j++){
    Particle current = particles.get(j);
    PVector position = current.position;
    if(current.checkSplit()){
      Particle[] splitting = partBuilder.splitParticle(currentWave, 2, (int)position.x, (int)position.y);
      for(int i = 0; i < splitting.length; i++){
        particles.add(splitting[i]);
      }
    }
  }
  Iterator iter = particles.iterator();
  while(iter.hasNext()){
    Particle current = (Particle)iter.next();
    current.render();
    for(int i = 0; i < cities.length; i++){
      City currentTarget = cities[i];
      if(detectCityCollision(current, currentTarget)){
        currentTarget.destroy();
      }
    }
    for(int i = 0; i < batteries.length; i++){
      MissileBattery currentTarget = batteries[i];
      if(detectBatteryCollision(current, currentTarget)){
        currentTarget.destroy();
      }
    }
    
    PVector position = current.position;
    if(position.y > displayHeight){
      iter.remove();
    }else{
      if(current.currentExplosionSize == PARTICLE_MAX_EXPLOSION_SIZE){
        iter.remove();
      }
    }
    if(detectCollision(current)){
      current.explode();
    }
    

    current.integrate(gravity);
  }
  if(firing){
    Iterator itr = missiles.iterator();
    while(itr.hasNext()){
      MissileParticle current = (MissileParticle)itr.next();
      current.render();
      detectSatelliteCollision(current);
      if (!current.targetReached()){
        current.integrate(gravity);
      }else{
        Iterator pIter = particles.iterator();
        while(pIter.hasNext()){
          Particle currentParticle = (Particle)pIter.next();
          if(detectCollision(current, currentParticle)){
            if(!currentParticle.isExploding()){
              particleScore();
            }
            currentParticle.explode();
            
          }
        }
      }
      
      
      if (current.currentExplosionSize == MISSILE_MAX_EXPLOSION_SIZE){
        itr.remove();
      }
      if (missiles.size() == 0){
        firing = false;
      }
      
    }
  }
  leftBattery.renderBattery();
  middleBattery.renderBattery();
  rightBattery.renderBattery();
  for(City current : cities){
    current.render();
  }
  if(satellite != null){
    satellite.dropParticle(particles, partBuilder, currentWave);
    satellite.render();
    satellite.integrate();
  }
  stroke(0, 0, 255);
  line(mouseX - 30, mouseY, mouseX + 30, mouseY);
  line(mouseX, mouseY - 30, mouseX, mouseY + 30);
  stroke(255, 255, 255);
  checkForEndOfWave();
  checkforGameOver();
  }else{
    background(0);
    textSize(100);
    fill(255);
    text("GAME OVER", (DISPLAY_WIDTH / 2) - 600, DISPLAY_HEIGHT / 2);
    text("YOUR SCORE: " + score, (DISPLAY_WIDTH / 2) - 600, (DISPLAY_HEIGHT) / 2 + 100);
    text("Press Any Key to Start Again", (DISPLAY_WIDTH / 2) - 600, (DISPLAY_HEIGHT) / 2 + 200);
  }
}

void keyPressed() {
  if(!gameOver){
  if(key == CODED){
    if(keyCode == LEFT){
      leftBattery.fire();
      firing = true;
    }else if(keyCode == UP){
      middleBattery.fire();
      firing = true;
    }else if(keyCode == RIGHT){
      rightBattery.fire();
      firing = true;
    }
  }
  }else{
    gameOver = false;
    startGame();
  }
}

boolean detectCollision(MissileParticle m, Particle p){
  PVector position1 = p.position.copy();
  PVector diff = position1.sub(m.position);
  float distance = diff.mag();
  return distance < m.currentExplosionSize;
}

boolean detectCityCollision(Particle p, City c){
  PVector particlePosition = p.position.copy();
  PVector cityCorner = c.getCorner();
  int width = c.getWidth();
  int height = c.getHeight();
  return (particlePosition.x > cityCorner.x && particlePosition.x < cityCorner.x + width
    && particlePosition.y > cityCorner.y);
}

boolean detectBatteryCollision(Particle p, MissileBattery m){
  PVector position = p.position.copy();
  int[] coords = m.getCentroid();
  PVector targetPos = new PVector(coords[0], coords[1]);
  PVector diff = position.sub(targetPos);
  int distance = (int)diff.mag();
  return distance < m.getRadius();
}

boolean detectCollision(Particle p){
  Iterator iter = particles.iterator();
  while(iter.hasNext()){
    Particle current = (Particle)iter.next();
    if (current.isExploding()){
      PVector position1 = p.position.copy();
      PVector position2 = current.position.copy();
      PVector diff = position2.sub(position1);
      int distance = (int)diff.mag();
      if (distance < current.currentExplosionSize){
        return true;
      } 
    }
  }
  return false;
}

void detectSatelliteCollision(MissileParticle m){
  if(satellite == null){return;}
  PVector missilePos = m.position.copy();
  PVector satPos = satellite.position.copy();
  PVector diff = missilePos.sub(satPos);
  int dist = (int)diff.mag();
  if (dist < m.currentExplosionSize + satellite.satRadius){
    satellite = null;
    satelliteScore();
  }
}


void checkForEndOfWave(){

  if(particles.size() == 0){
    nextWave();
  }
}

void nextWave(){
  endOfWaveScore();
  currentWave++;
  batteries[0].reset();
  batteries[1].reset();
  batteries[2].reset();
  splitting = new int[currentWave];
  for(int i = 0; i < splitting.length; i++){
    int splitIndex = (int)random(0, currentWave - 1);
    splitting[i] = splitIndex;
  }
  for (int i = 0; i < num_particles + currentWave; i++){ 
    Particle newParticle = partBuilder.createParticle(currentWave);
    for(int j = 0; j < splitting.length; j++){
      if(splitting[j] == i){
        newParticle.willSplit();
        newParticle.setSplitPos((int)random(100, 800));
      }
    }
    particles.add(newParticle);
  }
  createSatellite();
  num_particles++;  

  
}

void checkforGameOver(){
  boolean remaining = false;
  for(int i = 0; i < cities.length; i++){
    if(!cities[i].isDestroyed()){
      remaining = true;
    }
  }
  if(!remaining){
    gameOver = true;
  }
}

void satelliteScore(){
  int points = multiplyScore(100);
  cityRestorePoints += points;
  score += points;
}

void particleScore(){
  int points = multiplyScore(25);
  
  cityRestorePoints += points;
  score += points;
}

void endOfWaveScore(){
  for(int i = 0; i < cities.length; i++){
    if(!cities[i].isDestroyed()){
      cityRestorePoints += multiplyScore(100);
      score += multiplyScore(100);
    }
  }
  for(int i = 0; i < batteries.length; i++){
    int remainingMissiles = batteries[i].getNumMissiles();
    int bonusPoints = 10 * remainingMissiles;
    cityRestorePoints += multiplyScore(bonusPoints);
    score += multiplyScore(bonusPoints);
  }

  if(cityRestorePoints > 10000){
    restoreCity();
  }

}

int multiplyScore(int points){
  if(currentWave == 3 || currentWave == 4){
    points = points * 2;
  }else if(currentWave == 5 || currentWave == 6){
    points = points * 3;
  }else if(currentWave == 7 || currentWave == 8){
    points = points * 4;
  }else if(currentWave == 9 || currentWave == 10){
    points = points * 5;
  }else if (currentWave > 10){
    points = points * 6;
  }
  return points;
}

void restoreCity(){

  for(int i = 0; i < cities.length; i++){
    City current = cities[i];
    if(current.isDestroyed()){
      current.restore();
      break;
    }
  }
  cityRestorePoints = 0;
}


void createSatellite(){
  if(currentWave > 1 ){
    satellite = new Satellite(0, (int)random(100, 600), 2.5f);
  }else{
    satellite = null;
  }
}

void splitParticle(){
  if(currentWave > 2){

  }
}