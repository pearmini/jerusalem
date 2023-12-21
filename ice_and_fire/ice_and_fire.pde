/*
based on : https://www.openprocessing.org/sketch/415191
*/
ParticleSystem ps;

void setup() {
  size(700, 700);
  colorMode(HSB, 360);
  ps = new ParticleSystem();
}

void draw() {
  background(300, ps.getSize()  , 360);
  ps.run();
  if (mousePressed && mouseButton == LEFT) {
    ps.addFire(mouseX, mouseY);
  }
}

class ParticleSystem {
  ArrayList<Particle> plist;
  
  ParticleSystem() {
    plist = new ArrayList<Particle>();
  }
  
  void run() {
    for (int i = plist.size() - 1; i >= 0; i--) {
      Particle p = plist.get(i);
    	  if (p.isDead()) {
        plist.remove(i);
      }
      p.run();
    }
  }
  
  void addFire(float x, float y) {
    plist.add(new Ice(x, y));
  }
  
  void addFire(float x, float y, float size) {
    plist.add(new Fire(x, y, size));
  };
  int getSize() {
    int cnt = 0;
    for (Particle p : plist) {
      cnt += p.type;
    }
    return cnt;
  }
}


class Particle {
  PVector location, velocity, acceleration, origin;
  float lifespan, lifeRate, hue, maxLifespan;
  float angle, aVelocity, aAcceleration;
  int type;
  
  Particle(float x, float y, int t) {
    type = t;
    origin = new PVector(x, y);
    location = new PVector();
    acceleration = new PVector(0, 0.05);
    velocity = PVector.random2D();
    lifespan = maxLifespan = 50;
    lifeRate = random(0.35, 1);
    hue = 20;
  }
  
  float getSpeed(float s) {
    float t = maxLifespan / lifeRate;
    return s / t;
  }
  
  void run() {
    	display();
    update();
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    
    aVelocity += aAcceleration;
    angle += aVelocity;
    
    lifespan -= lifeRate;
  }
  
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
  
  void display() {
    pushMatrix();
    translate(origin.x, origin.y);
    rotate(radians(angle));
    translate(location.x, location.y);
    scale(map(lifespan, 0, maxLifespan, 0, 1));
    drawShape();
    popMatrix();
  }
  
  void drawShape() {
    stroke(hue, 255, 255);
    strokeWeight(30);
    point(0, 0);
  }
}


class Ice extends Particle {
  ArrayList<PVector> plist;
  float theta;
  Ice(float x, float y) {
    super(x, y, 1);
    
    PVector v = new PVector(mouseX - pmouseX, mouseY - pmouseY);
    v.mult(0.1);
    velocity.mult(getSpeed(100));
    	velocity.add(v);
    
    plist = new ArrayList();
    for (int i = 0; i < 3; i++) {
      float xOffset = random( - 10, 10);
      float yOffset = random( - 10, 10);
      float hue = random(135, 185);
      plist.add(new PVector(xOffset, yOffset, hue));
    }
    
    theta = random(TAU);
    hue = 165;
  }
  
  void update() {
    super.update();
    if (int(random(5)) == 0) {
      int spawnCount = int(random(3)) + 1;
      for (int i = 0; i < spawnCount; i++) {
        spawn();
      }
    }
  }
  
  void spawn() {
    float size = random(25, 50) * map(lifespan, maxLifespan, 0, 1, 0);
    	if (size > 0) {
      ps.addFire(location.x + origin.x, location.y + origin.y, size);
      	}
  }
  
  void drawShape() {
    noStroke();
    rotate(theta);
    for (PVector p : plist) {
      stroke(hue + lifespan * 1.5, 360, 360, 50);
      strokeWeight(80);
      point(p.x, p.y);
      stroke(hue + lifespan * 1.5, 360, 360, 180);
      strokeWeight(30);
      point(p.x, p.y);
    }
  }
}


class Fire extends Particle {
  float size, alpha;
  float theta;
  Fire(float x, float y, float _size) {
    super(x, y, 0);
    size = _size;
    lifespan = maxLifespan = 30;
    lifeRate = random(0.4, 1.25);
    
    angle = random( - 45, 45);
    aVelocity = random( - 2, 2);
    
    velocity.set(0, getSpeed(random( - 100, -100)));
    acceleration.mult(0);
    theta = random(TAU);
    
    hue = 130;
    size *= 1.5;
    alpha = random(100, 200);
  }
  
  void drawShape() {
    rotate(theta);
    fill(10 + lifespan * 1.2, 360, 360, alpha);
    noStroke();
    triangle( - size / 2, 0, size / 2, 0, 0, size * sqrt(3) / 2);
  }
}
