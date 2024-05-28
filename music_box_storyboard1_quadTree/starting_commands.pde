void keyPressed() {
  if (key == 'a' || key == 'A') {
    startVideoPlayback();
  }
}

void startVideoPlayback() {
  videoStarted = true;
  mov[currentMovie].play();
  p2Changed = true; // Set the flag to ignore further changes
  println("Video started.");
  // Sending message to Max to start video playback
  OscMessage msg = new OscMessage("/startMelody");
  msg.add(p2);
  oscP5.send(msg, dest);
}
