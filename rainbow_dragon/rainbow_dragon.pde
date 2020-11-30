Brush brush;
void setup() {
	size(800, 800);
	background(255, 255, 0);
	colorMode(HSB);
	brush = new Brush();
}
void draw() {
	brush.draw();
	brush.update();
}


class Brush{
	PVector location;
	float angle;
	float hu;
	float size;
	float seedX,seedY, seedAngle, seedHu, seedSize;
	
	Brush() {
		seedX = random(10);
		seedY = random(10);
		seedAngle = random(10);
		seedHu = random(10);
		seedSize = random(10);
		location = new PVector();
	}
	
	void draw() {
		pushMatrix();
		fill(hu, 360, 360, 100);
		translate(location.x,location.y);
		rotate(angle);
		rect(0, 0, size, size);
		popMatrix();
	}
	
	void update() {
		location.x = map(noise(seedX), 0, 1, 0, width);
		location.y = map(noise(seedY), 0, 1, 0, height);
		angle = map(noise(seedAngle), 0, 1, 0, TWO_PI);
		hu = map(noise(seedAngle,seedSize), 0, 1, 0, 360);
		size = map(noise(seedSize), 0, 1, 0,100);
		seedX += 0.01;
		seedY += 0.01;
		seedAngle += 0.01;
		seedHu += 0.01;
		seedSize += 0.01;
	}
}
