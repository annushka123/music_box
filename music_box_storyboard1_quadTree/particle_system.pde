



class ParticleSystem {
  ArrayList<Particle> particles;
  PVector offset;
  float radius;
  
  ParticleSystem(float offsetX, float offsetY, float radius) {
    particles = new ArrayList<Particle>();
    offset = new PVector(offsetX, offsetY);
    this.radius = radius;
    
    
  }
  
  void addImageParticle(float x, float y, color c) {
    particles.add(new ImgParticle(x+offset.x, y+offset.y, c));
    
    
  }
  

    void addParticles(float x, float y, int numParticles) {
    for (int i = 0; i < numParticles; i++) {
      float angle = random(TWO_PI);
      float r = random(radius);
      float px = x + offset.x + cos(angle) * r;
      float py = y + offset.y + sin(angle) * r;
      particles.add(new Particle(px, py));
    }
  }
  
    void applyForce(PVector force) {
      for(Particle p : particles) {
        p.applyForce(force);
      }
    }
    
    void applyUniqueForce() {
    for (Particle p : particles) {
      
        PVector uniqueWind = new PVector(random(-.5, 2), random(-2, 2));
        uniqueWind.mult(1.5);
        // Generate a unique random force for each particle
       if (p instanceof ImgParticle) { // Check if the particle is an instance of ImgParticle

        p.applyForce(uniqueWind);
       }

    }
}

  void updateParticleSpeed() {
    for(Particle p: particles) {

      float newParticleSpeed = map(p1, 0., 1., -1., 1.1);
      
      PVector wind = new PVector(newParticleSpeed, newParticleSpeed);
      p.applyForce(wind);
      //println("wind:", wind);
      println("newParticleSpeed:", newParticleSpeed);
    }
  }
      


  void fadeIn() {
    for(Particle p: particles) {
      p.fadeIn();
    }
  }
  
    void clearImageParticles() {
        for (int i = particles.size() - 1; i >= 0; i--) { // Iterate backwards to avoid concurrent modification issues
            Particle p = particles.get(i);
            if (p instanceof ImgParticle) { // Check if the particle is an instance of ImgParticle
                particles.remove(i); // Remove the ImgParticle from the list
            }
        }
    }
  void run() {
    
     for(int i=particles.size()-1; i>=0; i--) {  
      Particle p = particles.get(i);
      p.update();
      p.display();
      //p.sendOsc();
      if(p.isDead()) {
      particles.remove(i);
      }
    }
  }   
}
