ParticleSystem ps;

void setup() {
  size(800, 800);
  ps = new ParticleSystem(new PVector());
}

void draw() {
  background(0);
  ps.run();
}

void mouseDragged() {
  ps.addParticle(mouseX, mouseY);
}

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector force;
  float lifeSpan;
  float speed;
  int cnt;
  
  Particle(PVector l, PVector f) {
    location = l.get();
    force = f.get();
    velocity = new PVector();
    acceleration = new PVector();
    lifeSpan = 1;
    cnt = 10;
    speed = random(13, 20);
  }

  void display() {
    fill(255);
    ellipse(location.x, location.y, 10, 10);
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    lifeSpan -= 0.01;
  }
  
  void applyForce(PVector force) {
    PVector f = new PVector(force.x, force.y);
    acceleration.add(f);
  }
  
  boolean isDead() {
    if (lifeSpan > 0.0) {
      return false;
    } else {
      return true;
    }
  }
  
  void run() {
    update();
  }
  
  ArrayList<Particle> explode() {
    ArrayList<Particle> pieces = new ArrayList<Particle>();
    for (int i = 0; i < cnt; i++) {
      PVector dir = PVector.random2D();
      pieces.add(new Particle(location, dir));
    }
    return pieces;
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  int distThresh = 100;
  
  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }
  
  void addParticle(float x, float y) {
    Particle p = new Particle(new PVector(x, y), new PVector());
    particles.addAll(p.explode());
  }
  
  void drawLines(Particle p1, Particle p2, Particle p3) {
    //draw the line if met the condition
    if (dist(p1.location.x, p1.location.y, p2.location.x, p2.location.y)>distThresh) {
      return;
    }
    if (dist(p3.location.x, p3.location.y, p2.location.x, p2.location.y)>distThresh) {
      return;
    }
    if (dist(p1.location.x, p1.location.y, p3.location.x, p3.location.y)>distThresh) {
      return;
    }
    
    noStroke();
    fill(random(255), random(255), 255);
    triangle(
      p1.location.x, p1.location.y, 
      p2.location.x, p2.location.y, 
      p3.location.x, p3.location.y
     );
  }
  
  
  void run() {
    for (int i = particles.size() - 1; i >= 2; i--) {
      //update the state of the dot
      Particle p3 = particles.get(i), p2 = particles.get(i - 1), p1 = particles.get(i - 2);
      drawLines(p1, p2, p3);
      p3.applyForce(PVector.div(p3.force, p3.speed));
      p3.run();
      if (p3.isDead()) {
        particles.remove(p3);
      }
    }
  }
}
