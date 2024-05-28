// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-11: Simple color tracking

import processing.video.*;
import oscP5.*;
import netP5.*;
import java.util.Iterator;


OscP5 oscP5;
NetAddress dest;

Movie[] mov = new Movie[3];
int currentMovie = 0;
int nextMovie = 0;
boolean crossfading = false;
boolean videoStarted = false;
float fadeAlpha = 0.0;
int fadeDuration = 2000;
int fadeStartTime;

PImage[] img = new PImage[11];
float edgeThreshold = 40;
int currentImage = 0;
PImage prev;

int currentState = 0;
int startTime = 0;
int waitDuration = 5000;

String currentMessage = "Waiting...";

ParticleSystem ps;

ArrayList<ParticleSystem> particleSystems;
ArrayList<ParticleSystem> newParticleSystems;

boolean particlesActive = false;

// Wekinator incoming variables
float p1, p2, p3, p4, p5, p6, p7;
int m1 = 0; // Current value of m1a
int previousM1 = 0; // Previous value of m1

float previousP2 = -1;
boolean p2Changed = false;

// Motion tracking variables
float motionX = 0;
float motionY = 0;
float lerpX = 0;
float lerpY = 0;

float speed = 1;
float threshold = 25;

int testCounter = 1;

void setup() {
  //fullScreen(2);
  size(1200, 800);
  ps = new ParticleSystem(0, 0, 50);
  particleSystems = new ArrayList<ParticleSystem>();
  newParticleSystems = new ArrayList<ParticleSystem>();
  loadMovies();
  loadImages();
  generateParticlesForImage(img[currentImage]);
  smooth();
  setupOSC();
}

void draw() {
  background(0);
  
  if (videoStarted) {
    processVideo();
    updatePixels();
  }
  updateMotionTracking();
  updateState();
  updateLerpedMotion();
  ps.updateParticleSpeed();


  if (particlesActive) { // Add particles continuously while the flag is active
    ps.addParticles(lerpX, lerpY, 5);
  }
  
  ps.run(); // Update and display the particle system


 Iterator<ParticleSystem> iterator = particleSystems.iterator();
  while (iterator.hasNext()) {
    ParticleSystem system = iterator.next();
    system.addParticles(lerpX, lerpY, 5); // Add multiple particles to each system
    system.run(); // Update and display all additional particle systems
  }

  // Add new particle systems from the temporary list
  particleSystems.addAll(newParticleSystems);
  newParticleSystems.clear(); // Clear the temporary list

  previousM1 = m1; // Update previous m1 for the next frame
  

}
