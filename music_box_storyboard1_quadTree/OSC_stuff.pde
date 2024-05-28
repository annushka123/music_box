
void setupOSC() {
  oscP5 = new OscP5(this, 12000);
  oscP5 = new OscP5(this, 12001);
  dest = new NetAddress("127.0.0.1", 6450);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if (theOscMessage.checkTypetag("ffffff")) { // Now looking for 6 parameters
      p1 = theOscMessage.get(0).floatValue();
      p2 = theOscMessage.get(1).floatValue();
      p3 = theOscMessage.get(2).floatValue();
      p4 = theOscMessage.get(3).floatValue();
      p5 = theOscMessage.get(4).floatValue();
      p6 = theOscMessage.get(5).floatValue();
      //println("p1:", p1, "p2:", p2, "p3:", p3);

      // Check for the change in p2 from 1 to 2
      if (previousP2 == 1 && p2 == 2 && !p2Changed) {
        videoStarted = true;
        mov[currentMovie].play();
        p2Changed = true; // Set the flag to ignore further changes
        println("p2 changed from 1 to 2, video started.");
        // Sending message to Max to start video playback
        OscMessage msg = new OscMessage("/startMelody");
        msg.add(p2);
        oscP5.send(msg, dest);
      }

      // Update the previous value of p2
      previousP2 = p2;
    } else {
      println("Error: unexpected params type tag received by Processing");
    }
  }


      
  if (theOscMessage.checkAddrPattern("/max/outputs") == true) {
    if (theOscMessage.checkTypetag("i")) {
      previousM1 = m1; // Update previous m1
      m1 = theOscMessage.get(0).intValue(); // Update current m1
      //println("m1: ", m1);

      if (m1 == 35 && previousM1 != 35) {
        particlesActive = true; // Start adding particles
        println("ParticleSystem Activated");
      }else if(m1 == 40 && previousM1 != 40) {
        float offsetX = random(-100, 100);
        float offsetY = random(-100, 100);
        float radius = 50;
        newParticleSystems.add(new ParticleSystem(offsetX, offsetY, radius));
        println("new particle system added" + offsetX + offsetY);
      } else if(m1 == 46 && previousM1 != 46) {
        float offsetX = random(-300, 10);
        float offsetY = random(width-100);
        float radius = 60;
        newParticleSystems.add(new ParticleSystem(offsetX, offsetY, radius));
        println("new particle system added" + offsetX + offsetY);
      } else if(m1 == 52 && previousM1 != 52) {
        float offsetX = random(200, 300);
        float offsetY = random(150, 300);
        float radius = 50;
        newParticleSystems.add(new ParticleSystem(offsetX, offsetY, radius));
        println("new particle system added" + offsetX + offsetY);
      } else if(m1 == 60 && previousM1 != 60) {
        float offsetX = random(10, 60);
        float offsetY = random(width*0.75);
        float radius = 30;
        newParticleSystems.add(new ParticleSystem(offsetX, offsetY, radius));
        println("new particle system added" + offsetX + offsetY);
      }
  
    
  


      // Check if m1 equals 36 to start crossfade to the next movie
      if (m1 == 74) {
        nextMovie = (currentMovie + 1) % mov.length;
        startCrossfade();
        println("Starting crossfade to next movie: " + nextMovie);
      }
    }
  }
}
