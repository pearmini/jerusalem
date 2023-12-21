/*
* based on: https://www.openprocessing.org/sketch/697891
*/
Shape s;
void setup() {
  size(600, 600);
  s = new Shape(width / 2, height / 3, 100, "Sad news!!!");
}  

void draw() {
  background(255);
  s.update();
  s.display();
}

void mouseMoved() {
  s.rotateText();
  s.rotateEye();
}

class Shape {
  //构成百变怪点的数量
  final int SEGMENT = 200;
  
  //百变怪的扭曲程度
  final float NOISE_SCALE = 1;
  ArrayList<PVector> points;
  ArrayList<PVector> chars;
  
  float x, y, r;
  
  //绘制字体的启始角度
  float startAngle;
  String message;
  PFont f;
  
  Eye left, right;
  
  Shape(float _x, float _y, float _r, String _message) {
    x = _x;
    y = _y;
    r = _r; 
    message = _message;
    
    //初始化构成百变怪的点。
    points = new ArrayList();
    for (int i = 0; i < SEGMENT; i++) {
      float theta = map(i, 0, SEGMENT - 1, 0, TAU);
      
      //初始化每一个的方向
      points.add(new PVector(theta, 0));
    }
    
    //初始化需要用到的字体，并进行设置。
    f = createFont("Helvetica", _r);
    textFont(f);
    textAlign(CENTER);
    
    //初始化需要展现的字母。
    chars = new ArrayList(); 
    float theta = 0;
    for (int i = 0; i < message.length(); i++) {
      char currentChar = message.charAt(i);
      float thetaStep = textWidth(currentChar) / (_r * 1.5);
      theta += thetaStep / 2;
      
      //初始化每一个的方向
      chars.add(new PVector(theta, 0, 0));
      theta += thetaStep / 2;
    }
    
    left = new Eye( - r / 1.8, r, r);
    right = new Eye(r / 1.8, r, r);
  }
  
  float rByTheta(float theta) {
    float time = float(frameCount) / 100;
    float scale = noise(cos(theta) + 1, sin(theta) + 1, time) * NOISE_SCALE + 1;
    return  r * (1 + cos(theta - PI / 2)) * scale;
  }
  
  float angleByTheta(float theta) {
    final float offset = 0.06;
    float theta1 = theta - offset, theta2 = theta + offset;
    float a = rByTheta(theta1);
    float b = rByTheta(theta2);
    return atan2(a * sin(theta1) - b * sin(theta2), a * cos(theta1) - b * cos(theta2)) + PI;
  }
  
  void rotateText() {
    startAngle = atan2(mouseY - y, mouseX - x);
  }
  
  void rotateEye() {
    left.update(mouseX - x, mouseY - y);
    right.update(mouseX - x, mouseY - y);
  }
  
  void update() {
    for (PVector p : points) {
      p.y = rByTheta(p.x);
    }
    
    for (PVector c : chars) {
      c.y = rByTheta(c.x + startAngle);
      c.z = angleByTheta(c.x + startAngle);
    }
  }
  
  void display() {
    //绘制百变怪
    translate(x, y);
    beginShape();
    fill(255, 255, 0);
    stroke(255, 255, 0);
    for (PVector p : points) {
      vertex(p.y * cos(p.x), p.y * sin(p.x));
    }
    endShape();
    
    //绘制文字
    fill(124, 44, 240);
    for (int i = 0; i < message.length(); i++) {
      PVector c = chars.get(i);
      pushMatrix();
      translate(c.y * cos(c.x + startAngle), c.y * sin(c.x + startAngle));
      rotate(c.z);
      text(message.charAt(i), 0, 0);
      popMatrix();
    }
    
    //绘制眼睛
    left.display();
    right.display();
  }
}

class Eye {
  float x, y, size, angle;
  Eye(float _x, float _y, float _size) {
    x = _x;
    y = _y;
    size = _size;
  }
  
  void update(float mx, float my) {
    angle = atan2(my - y, mx - x);
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    fill(255);
    stroke(255);
    ellipse(0, 0, size, size);
    rotate(angle);
    fill(0);
    ellipse(size / 4, 0, size / 2, size / 2);
    popMatrix();
  }
}
