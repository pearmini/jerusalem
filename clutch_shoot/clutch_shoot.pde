void setup() {
  size(1500, 800);
}

void draw() {
  background(255, 255, 255);
  strokeWeight(10);
  
  //draw the baskerball net
  fill(255, 0, 0);
  rect(700, 300, 750, 400);
  
  //draw the basketball
  fill(255, 0, 0);
  rect(700, 50, 200, 200);
  
  //draw the shooter
  //head
  fill(255, 0, 0);
  rect(200, 400, 150, 150);
  //body
  fill(0, 0, 0);
  rect(275, 550, 75, 150);
  //left arm
  fill(200, 200, 200);
  rect(350, 300, 100, 50);
  //rigt arm
  rect(350, 350, 50, 200);
  //right foot
  fill(200, 200, 200);
  rect(325, 700, 25, 75);
  //left foot
  rect(350, 700, 100, 50);
  
  //draw the defender
  //head
  fill(255, 0, 0);
  rect(450, 550, 100, 100);
  //body
  fill(0, 0, 0);
  rect(500, 650, 50, 75);
  //left arm
  fill(200, 200, 200);
  rect(500, 650, 75, 25);
  //right arm
  rect(450, 500, 25, 50);
  //left foot
  fill(200, 200, 200);
  rect(525, 725, 100, 25);
  
  //draw the interval section 
  //interval between backboard and basketball
  fill(255, 255, 255);
  rect(700, 250, 700, 50);
  //interval of the most right
  //top
  fill(0, 0, 255);
  rect(1300, 10, 195, 290);
  //bottom
  fill(255, 255, 0);
  rect(1450, 300, 45, 495);
  
  //interval of the most bottom 
  //left
  fill(255, 255, 0);
  rect(600, 700, 100, 95);
  //right
  fill(255, 255, 255);
  rect(700, 700, 400, 95);
  fill(255, 255, 255);
  rect(1100, 700, 350, 95);
  fill(0, 0, 255);
  rect(1100, 700, 225, 95);
  
  //interval behind the defender
  fill(0, 0, 255);
  rect(600, 50, 100, 650);
  
  //interval of the top 
  //left
  fill(255, 255, 0);
  rect(900, 10, 400, 240);
  
  //rgiht
  fill(255, 255, 255);
  rect(700, 10, 200, 40);
  rect(600, 10, 100, 45);
  
  //interval up the defender
  //first
  fill(255, 255, 0);
  rect(450, 10, 150, 350);
  //second
  fill(255, 255, 255);
  rect(450, 350, 150, 50);
  //third
  fill(255, 255, 0);
  rect(450, 400, 150, 100);
  //forth
  fill(255, 255, 0);
  rect(555, 500, 45, 150);
  //fifth
  fill(255, 255, 255);
  rect(575, 650, 25, 75);
  
  //interval between the players
  fill(255, 255, 255);
  rect(350, 550, 100, 75);
  rect(350, 625, 100, 75);
  rect(450, 650, 50, 125);
  
  //intercal of up the attacker
  fill(255, 255, 255);
  rect(5, 10, 445, 95);
  fill(0, 0, 255);
  rect(5, 100, 445, 100);
  //interval behind the attacker
  //first
  fill(255, 255, 0);
  rect(5, 200, 195, 200);
  fill(255, 255, 255);
  rect(200, 200, 150, 200);
  //second
  fill(0, 0, 255);
  rect(5, 400, 100, 395);
  //third
  fill(255, 255, 0);
  rect(105, 550, 175, 245);
  
  //interval of the bottom of the players
  //last
  fill(255, 255, 255);
  rect(280, 775, 320, 25);
  
  //second
  fill(255, 255, 0);
  rect(355, 750, 245, 25);
}
