import gab.opencv.*;
import processing.video.*;

Capture video;
OpenCV opencv;


void setup() {
  size(500, 400);
  video = new Capture(this, width, height);
  video.start();
  opencv = new OpenCV(this, 500, 400);
  opencv.startBackgroundSubtraction(5, 3, 0.5);

}

// New frame available from camera
void captureEvent(Capture video) {
  video.read();
}

void draw() {
  image(video, 0, 0);
  
  if (video.width == 0 || video.height == 0)
    return;

  opencv.loadImage(video);
  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }
}
