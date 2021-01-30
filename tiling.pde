class Point {
  PVector pos; 
  color c; 

  Point(PVector pos, color c) {
    this.pos = pos;
    this.c = c;
  }

  Point() {
    this(new PVector(random(width), random(height)), color(random(255), random(255), random(255)));
  }

  void show() {
    fill(255);
    stroke(0);
    strokeWeight(2);
    ellipse(this.pos.x, this.pos.y, 20, 20);
  }
}

boolean CONSTANT_COLOR = false; 
final int POINTS = 10; 

Point[] points = new Point[POINTS];
Point[] nextPoints = new Point[POINTS];

void setup() {
  size(800, 800);
  for (int i = 0; i < points.length; i++) {
    points[i] = new Point();
  }
  for (int i = 0; i < points.length; i++) {
    nextPoints[i] = new Point();
  }
}

float pct = 0.00;

void draw() {
  background(51);

  loadPixels();

  if (mousePressed) {
    CONSTANT_COLOR = false;
  } else {
    CONSTANT_COLOR = true;
  }

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      float minDist = Float.POSITIVE_INFINITY;
      Point closest = null;
      for (Point p : points) {
        float d = dist(x, y, p.pos.x, p.pos.y);
        if (d < minDist) {
          closest = p; 
          minDist = d;
        }
      }
      int idx = y * width + x; 
      pixels[idx] = closest.c;
    }
  }



  updatePixels();

  for (int i = 0; i < points.length; i++) {
    Point p = points[i];
    p.pos.lerp(nextPoints[i].pos, pct += (mouseX * 0.00005));
    if (!CONSTANT_COLOR) 
      p.c = lerpColor(p.c, nextPoints[i].c, pct);
    p.show();
  }

  if (pct >= 1) {
    pct = 0; 
    for (int i = 0; i < points.length; i++) {
      points[i] = new Point(points[i].pos, points[i].c);
    }
    //nextPoints = new Point[10];
    for (int i = 0; i < points.length; i++) {
      color clr = CONSTANT_COLOR ? points[i].c : color(random(255), random(255), random(255));
      nextPoints[i] = new Point(new PVector(random(width), random(height)), clr);
    }
  }

  //saveFrame("tiling/####.png");
}
