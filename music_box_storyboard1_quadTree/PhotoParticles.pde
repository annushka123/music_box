class ImgParticle extends Particle {

  color c;

  

  ImgParticle(float x, float y, color c) {
    super(x, y);
    //acceleration = new PVector(0.1, 0.1);
    //velocity = new PVector(0.01, 0.01);
    //position = new PVector(x, y);
    this.c = c;
  }
  


  void display() {
    noStroke();
    fill(c, counter);
    ellipse(position.x, position.y, 5, 5); // Adjust ellipse size as needed
  }
  

  

}
