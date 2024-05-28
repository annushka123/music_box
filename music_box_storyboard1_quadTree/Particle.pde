// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Particle System

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float counter;
 

  Particle(float x, float y) {
    acceleration = new PVector(0.08, 0.08);
     velocity = PVector.random2D();
    velocity.mult(random(0.5, 1.5));
    position = new PVector(x, y);
    lifespan = 255.0;
  }
  
    void applyForce(PVector force) {
    acceleration.add(force);
    
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    lifespan -= 0.5;
  }
  


  // Method to display
  void display() {
    //stroke(255, lifespan);
    fill(random(127), random(120), random(255), lifespan);
    ellipse(position.x, position.y, 5, 5);
  }
  
  
   void fadeIn() {
     
    counter += 2.2; // Adjust the speed of fading in
    counter = constrain(counter, 0, 255);
  
}



  // Is the particle still useful? 
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}
  
  
  
  
