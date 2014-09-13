// Clickable site percolation
// Howard Cheng

int cellSize = 50;
float slope = 1.0/sqrt(3);
HashMap drawnTriangles = new HashMap;

void setup(){
  size(1024, 1024);
  strokeWeight(1);
  frameRate(15);
}

void draw(){
  background(245, 245, 245);
  stroke(225, 225, 225);
  drawGrid();

  Iterator iter = drawnTriangles.entrySet().iterator();
  while (iter.hasNext()) {
    Map.Entry me = (Map.Entry)iter.next();
    gridTriangle triangleCurr = me.getValue();
    triangleCurr.update();
  }
}

void mouseClicked() {
  // Each triangle in the grid is uniquely specified by
  // three numbers: the number of vertical grid lines lying strictly
  // to the left of the triangle tip, the number of upwards sloping
  // grid lines lying above, and the number of downward sloping grid
  // lines lying above.
  int vertLineIndex = floor(2.0 * slope * mouseX/cellSize);
  int upwardLineIndex = floor((mouseX * slope + mouseY)/cellSize);
  int downwardLineIndex = floor((-mouseX * slope + mouseY)/cellSize);

  String triangleIndex = vertLineIndex + "," + upwardLineIndex + ","
                         + downwardLineIndex;

  gridTriangle storedTriangle = drawnTriangles.get(triangleIndex);

  // Update color if already drawn, else add to hash map
  if(storedTriangle) {
    storedTriangle.colorState = (storedTriangle.colorState + 1) % 4;
  } else {
    gridTriangle pressedTriangle = new gridTriangle(vertLineIndex,
                                                    upwardLineIndex,
                                                    downwardLineIndex);
    pressedTriangle.update();
    drawnTriangles.put(triangleIndex, pressedTriangle);
  }
}

class gridTriangle {
  int colorState;
  float p1_x, p1_y, p2_x, p2_y, p3_x, p3_y;

  gridTriangle(vIndex, uIndex, dIndex) {
    colorState = 0;

    // Compute grid triangle vertices from the index
    float yInterceptU = cellSize * uIndex;
    float yInterceptD = cellSize * dIndex;
    float xInterceptV = (cellSize * vIndex)/(2.0 * slope);

    p1_x = (yInterceptU - yInterceptD)/(2.0 * slope);
    p1_y = (yInterceptU + yInterceptD)/2.0;

    p2_x = p1_x;
    p2_y = p1_y + cellSize;

    if(xInterceptV < p1_x) {
      p3_x = p1_x - cellSize/(2.0 * slope);
    } else {
      p3_x = p1_x + cellSize/(2.0 * slope);
    }
    p3_y = p1_y + cellSize/2.0;
  }

  void update() {
    switch(colorState) {
      case 0:
        fill(255, 0, 0);
        stroke(255, 0, 0);
        break;
      case 1:
        fill(0, 255, 0);
        stroke(0, 255, 0);
        break;
      case 2:
        fill(0, 0, 255);
        stroke(0, 0, 255);
        break;
      default: // uncolor
        stroke(245);
        return;
    }

    triangle(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y);
    stroke(245);
  }
}

void drawGrid(){
  int yStep = cellSize;
  for(int i = -height; i * yStep < 2 * height; i++) {
    line(0, i * yStep, width, i * yStep + slope * width);
    line(0, i * yStep, width, i * yStep - slope * width);
  }

  int xStep = cellSize/2 * 1/slope;
  for(int i = 0; i * xStep < width; i++){
    line(i * xStep, 0, i * xStep, height);
  }
}
