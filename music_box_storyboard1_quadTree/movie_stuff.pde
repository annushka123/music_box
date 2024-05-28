


void loadMovies() {
  for (int i = 0; i < mov.length; i++) {
    mov[i] = new Movie(this, "music_box" + i + ".mp4");
  }
  prev = createImage(width, height, RGB);
}

void movieEvent(Movie m) {
  m.read();
}

void processPixels() {
  int count = 0;
  float avgX = 0;
  float avgY = 0;

  loadPixels();
  prev.loadPixels();

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;

      color currentColor = pixels[loc];
      color prevColor = prev.pixels[loc];
      float d = distSq(red(currentColor), green(currentColor), blue(currentColor), red(prevColor), green(prevColor), blue(prevColor));

      if (d < threshold * threshold) {
        avgX += x;
        avgY += y;
        count++;
        pixels[loc] = color(10, 10, 10);
      } else {
        if (isLightColor(currentColor)) {
          pixels[loc] = color(10, 10, 10);
        } else {
          pixels[loc] = color(190, 130, 100, 150);
        }
      }
    }
  }

  if (count > 400) {
    motionX = avgX / count;
    motionY = avgY / count;
  }
}

boolean isLightColor(color c) {
  return red(c) > 100 && green(c) > 100 && blue(c) > 100;
}

void updateSpeed() {
  float newSpeed = map(p5, 0., 1., 0.1, 1.);
  mov[currentMovie].speed(newSpeed);

  OscMessage msg = new OscMessage("/movieSpeed");
  msg.add(newSpeed);
  oscP5.send(msg, dest);
}

void updateMotionTracking() {
  prev.loadPixels();
  threshold = 100;
}

void updateState() {
  switch (currentState) {
    case 0:
      if (p7 == 2.0) {
        currentState = 1;
        startTime = millis();
        currentImage = int(random(img.length));
        generateParticlesForImage(img[currentImage]);
      }
      break;
    case 1:
      ps.fadeIn();
      if (millis() - startTime > waitDuration) {
        currentState = 2;
        startTime = millis();
      }
      break;
    case 2:
      ps.applyUniqueForce();
      if (millis() - startTime > waitDuration) {
        ps.clearImageParticles();
        currentState = 0;
      }
      break;
    case 3:
      if (p7 == 1.0) {
        ps.clearImageParticles();
        currentState = 0;
      }
      break;
  }
}

void updateLerpedMotion() {
  lerpX = lerp(lerpX, motionX, random(0.1));
  lerpY = lerp(lerpY, motionY, random(1));
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1);
}

void processVideo() {
  if (crossfading) {
    handleCrossfade();
  } else {
    if (mov[currentMovie].available()) {
      mov[currentMovie].read();
    }
    tint(255);
    image(mov[currentMovie], 0, 0, width, height);
    restartMovieIfNeeded();
  }
  processPixels();
  //updateSpeed();
  //handleParticles();
 
}

void handleCrossfade() {
  int elapsed = millis() - fadeStartTime;
  fadeAlpha = map(elapsed, 0, fadeDuration, 0, 255);

  if (elapsed >= fadeDuration) {
    crossfading = false;
    currentMovie = nextMovie;
    mov[currentMovie].play();
    mov[(currentMovie - 1 + mov.length) % mov.length].stop();
  } else {
    readMoviesForCrossfade();
    applyCrossfade();
  }
}

void readMoviesForCrossfade() {
  if (mov[currentMovie].available()) {
    mov[currentMovie].read();
  }
  if (mov[nextMovie].available()) {
    mov[nextMovie].read();
  }
}

void applyCrossfade() {
  tint(255, 255 - fadeAlpha);
  image(mov[currentMovie], 0, 0, width, height);
  tint(255, fadeAlpha);
  image(mov[nextMovie], 0, 0, width, height);
}

void restartMovieIfNeeded() {
  if (mov[currentMovie].time() >= mov[currentMovie].duration() - 0.05) {
    mov[currentMovie].jump(0);
    mov[currentMovie].play();
  }
}

void startCrossfade() {
  crossfading = true;
  fadeAlpha = 0;
  fadeStartTime = millis();
  mov[nextMovie].play();
}
