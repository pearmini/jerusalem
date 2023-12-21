/*
Based on: https://www.openprocessing.org/sketch/567018
Santiago Fiorino
*/
Planet p;
void setup() {
  size(700, 700);
  p = new Planet(width / 2, height / 2, 100);
}

void draw() {
  background(233);
  
  p.update();
  p.display();
  
}

void mousePressed() {
  if (p.isInBody()) {
    p.addTree();
  }
}

void mouseMoved() {
  p.rotateAngle();
}

class Planet {
  final int MAX_TREE_COUNT = 3;
  float x, y, r, rotateTheta;
  float oribitWidth, oribitHeight;
  float ballAngle, ballSpeed;
  ArrayList<Tree> trees;
  Planet(float _x, float _y, float _r) {
    x = _x;
    y = _y;
    trees = new ArrayList();
    r = _r;
    oribitWidth = 5 * _r;
    oribitHeight = _r;
    ballSpeed = 1.5;
    rotateTheta = radians( - 25);
  }
  
  void update() {
    // delete extra tree
    int cnt = trees.size() -  MAX_TREE_COUNT;
    if (cnt >= 0) {
      for (int i = 0; i < cnt; i++) {
        trees.get(i).die();
      }
    }
    
    // update the trees
    for (int i = trees.size() - 1; i >= 0; i--) {
      Tree t = trees.get(i);
      if (t.isDead) {
        trees.remove(t);
        continue;
      }
      t.angle = angleByTheta(t.theta);
      t.r = rByTheta(t.theta);
      t.update();
    }
    
    // update the ball
    ballAngle += ballSpeed;
    ballAngle %= 360;
  }
  
  float rByTheta(float theta) {
    float scale = noise(sin(theta) + 1, cos(theta) + 1, float(frameCount) / 100);
    return r * (scale / 2 + 1);
  }
  
  float angleByTheta(float theta) {
    final float offset = 0.06;
    float theta1 = theta - offset, theta2 = theta + offset;
    float a = rByTheta(theta1);
    float b = rByTheta(theta2);
    return atan2(a * sin(theta1) - b * sin(theta2), a * cos(theta1) - b * cos(theta2));
  }
  
  void displayTrace(float startAngle, float endAngle) {
    pushMatrix();
    // shake
    float theta = map(noise(float(frameCount) / 100), 0, 1, 0, 25);
    rotate(radians(theta));
    
    // back
    noFill();
    stroke(233);
    strokeWeight(12);
    arc(0, 0, oribitWidth, oribitHeight, startAngle, endAngle);
    
    // front
    stroke(0);
    strokeWeight(4);
    arc(0, 0, oribitWidth, oribitHeight, startAngle, endAngle);
    popMatrix();
  }
  
  void displayBody() {
    fill(0);
    strokeWeight(5);
    stroke(233);
    beginShape();
    for (int i = 0; i <= 360; i += 5) {
      float theta = radians(i);
      float pr = rByTheta(theta);
      float px = pr * cos(radians(i)), py = pr * sin(radians(i));
      vertex(px, py);
    }
    endShape();
  }
  
  void displayBall() {
    pushMatrix();
    //shake
    float seed = noise(float(frameCount) / 100);
    float angle = map(seed, 0, 1, 0, 25);
    float offsetY = map(seed, 0, 1, -20, 20);
    rotate(radians(angle));
    float theta = radians(ballAngle);
    fill(240);
    strokeWeight(5);
    stroke(0);
    ellipse(oribitWidth * cos(theta) / 2, oribitHeight * sin(theta) / 2 + offsetY, 35, 35);
    popMatrix();
  }
  
  void display() {
    translate(x, y);
    rotate(rotateTheta);
    
    // display the body and trace of the planet
    displayTrace(PI, TWO_PI);
    if (ballAngle < 180) {
      displayBody();
      displayTrace(0, PI);
      displayBall();
    } else {
      displayBall();
      displayBody();
      displayTrace(0, PI);
    }
    
    // display the trees
    for (Tree t : trees) {
      t.display();
    }
  }
  
  void addTree() {
    float mx = mouseX, my = mouseY;
    float theta = atan2(my - y, mx - x) - rotateTheta;
    int type = int(random(3));
    Tree t = new Tree(theta, type);
    t.r = rByTheta(t.theta);
    t.angle = angleByTheta(t.theta);
    trees.add(t);
  }
  
  void rotateAngle() {
    if (!isInBody()) {
      float theta1 = atan2(mouseY - y, mouseX - x);
      float theta2 = atan2(pmouseY - height / 2, pmouseX - width / 2);
      rotateTheta += theta1 - theta2;
    }
  }
  
  boolean isInBody() {
    float mx = mouseX, my = mouseY;
    float theta = atan2(my - y, mx - x);
    float r = rByTheta(theta);
    if (dist(mx, my, x, y) < r) {
      return true;
    }
    return false;
  }
  
}


class Tree {
  static final int MAX_DEPTH = 4, MAX_LEN = 60, MIN_LEN = 30;
  float theta, r, angle;
  ArrayList<Branch> branches;
  ArrayList<Flower> flowers;
  PVector location;
  boolean isDead, isBlow;
  int type;
  Tree(float _theta, int _type) {
    theta = _theta;
    branches = new ArrayList();
    flowers = new ArrayList();
    Branch root = new Branch(0, 0, HALF_PI, random(MIN_LEN, MAX_LEN), 0, null);
    root.isGrowing = true;
    type = _type;
    location = new PVector();
    
    addBraches(root);
  }
  
  void addBraches(Branch b) {
    branches.add(b);
    int cnt = int(random(2, 4));
    if (b.level > MAX_DEPTH) {
      for (int i = 0; i < cnt; i++) {
        float offset = random( - 10, 10);
        float c1 = random(255), c2 = random(255);
        color c = type == 0 ? color(c1, c2, 255) : type == 1 ? color(c1, 255, c2) : color(255, c1, c2);
        Flower f = new Flower(b, offset, c);
        flowers.add(f);
      }
    } else {
      float startAngle = -PI / 4, endAngle = PI / 4;
      float angle = (endAngle - startAngle) / cnt;
      for (int i = 0; i < cnt; i++) {
        float offset = random(startAngle + angle * i, startAngle + angle * (i + 1));
        Branch t = new Branch(b.to.x, b.to.y, b.theta - offset, b.len * 0.8, b.level + 1, b);
        addBraches(t);
      }
    }
  }
  
  void die() {
    for (Branch b : branches) {
      if (b.level == MAX_DEPTH + 1) {
        b.isDying = true;
      }
    }
  }
  
  void update() {
    location.set(r * cos(theta), r * sin(theta));
    if (branches.get(0).isDead) {
      isDead = true;
    }
    for (Branch b : branches) {
      b.update();
    }
    
    for (int i = 0; i < flowers.size(); i++) {
      Flower f = flowers.get(i);
      if (f.isFlying && !f.isDown) {
        PVector gravity = PVector.sub(new PVector(0, -100), f.location);
        if (abs(gravity.mag() - random(20, 80)) < 10) {
          f.velocity.set(0, 0);
          f.accerlation.set(0, 0);
          f.isDown = true;
        } else {
          gravity.normalize();
          gravity.mult(0.1);
          f.applyForce(gravity);
        }
      }
      
      f.update();
    }
  }
  
  void blow() {
    isBlow = true;
    for (Flower f : flowers) {
      f.down();
      f.isFlying = true;
    }
  }
  
  void display() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(angle);
    for (Branch b : branches) {
      if (PVector.dist(b.from, b.current) > 0.1) {
        b.display();
      }
    }
    
    for (Flower f : flowers) {
      if (!f.isDown) {
        f.display();
      }
    }
    popMatrix();
  }
}

class Branch {
  Branch father;
  PVector from, to, current;
  float theta, len, sw;
  boolean isDying, isGrowing, isGrown, isDead;
  int level;
  Branch(float fromX, float fromY, float _theta, float _len, int _level, Branch _father) {
    theta = _theta;
    len = _len;
    level = _level;
    sw = map(level, 0, Tree.MAX_DEPTH, 5, 2);
    
    from = new PVector(fromX, fromY);
    current = new PVector(fromX, fromY);
    to = new PVector(fromX + len * cos(theta), fromY + len * sin(theta));
    
    father = _father;
  }
  
  void update() {
    if (isDying) {
      current = PVector.lerp(current, from, 0.2);
      if (PVector.dist(current, from) < 0.1) {
        isDead = true;
        if (father != null) {
          father.isDying = true;
        }
      }
    } else if (isGrowing) {
      current = PVector.lerp(current, to, 0.1);
      if (PVector.dist(current, to) < 0.1) {
        isGrown = true;
      }
    } else if (!isGrowing && !isDying) {
      if (father.isGrown) {
        isGrowing = true;
      }
    }
  }
  
  void display() {
    strokeWeight(sw);
    stroke(0);
    line(from.x, from.y, current.x, current.y);
  }
}


class Flower {
  PVector velocity, accerlation, location, origin;
  boolean isGrown, isFlying, isDown;
  Branch father;
  color c;
  Flower(Branch _father, float _offset, color _c) {
    father = _father;
    location = new PVector(father.to.x + _offset, father.to.y + _offset);
    velocity = new PVector();
    accerlation = new PVector();
    origin = new PVector(0, -100);
    c = _c;
  }
  
  void down() {
    velocity = PVector.random2D();
    velocity.mult(1.5);
  }
  
  void applyForce(PVector force) {
    if (isGrown) {
      accerlation.add(force);
    }
  }
  
  void update() {
    if (father.isGrown) {
      isGrown = true;
    }
    
    if (father.isDying) {
      if (!isDown && !isFlying) {
        down();
        isFlying = true;
      }
    }
    
    if (isGrown) {
      velocity.add(accerlation);
      location.add(velocity);
      accerlation.mult(0);
    }
  }
  
  void display() {
    if (isGrown) {
      fill(c);
      noStroke();
      ellipse(location.x, location.y, 6, 6);
    }
  }
}
