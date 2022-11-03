// Example 16-5: Scrubbing forward and backward in movie

// If mouseX is 0, go to beginning
// If mouseX is width, go to end
// And everything else scrub in between

import processing.video.*;

Movie movie;

void setup() {
  size(920, 740, P3D);
  movie = new Movie(this, "Montagne - 81945.mp4");
  movie.loop();
}

void draw() {

 movie.speed(2);
  // Read frame
  movie.read(); 
  // Display frame
  image(movie, 0, 0);
}
