class Point {
  PVector pos; 
  color c; 

  Point(color c) {
    this.pos = new PVector(random(width), random(height));
    this.c = c;
  }

  Point() {
    this(color(random(255), random(255), random(255)));
  }

  void show() {
    fill(255);
    stroke(0);
    strokeWeight(2);
    ellipse(this.pos.x, this.pos.y, 6, 6);
  }
}

Point[] points = new Point[10];
Point[] nextPoints = new Point[10];

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
    p.pos.lerp(nextPoints[i].pos, pct += 0.001);
    p.show();
  }

  if (pct >= 1) {
    pct = 0; 
    points = nextPoints; 
    nextPoints = new Point[10];
    for (int i = 0; i < points.length; i++) {
      nextPoints[i] = new Point(points[i].c);
    }
  }

  //saveFrame("tiling/####.png");
  
}
