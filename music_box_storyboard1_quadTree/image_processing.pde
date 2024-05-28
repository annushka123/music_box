
void loadImages() {
  for (int i = 0; i < img.length; i++) {
    img[i] = loadImage("photo" + i + ".jpg");
    img[i].resize(width, height);
    img[i].loadPixels();
  }
}

void convertToGrayscale(PImage img) {
  img.loadPixels();
  
  float edgeThreshold = 40;
  
    for (int x = 1; x < width; x++) {
    for (int y = 0; y < height; y++) {

      int loc = x + y * img.width;
      color pix = img.pixels[loc];

      float r = red(pix);
      float g = green(pix);
      float b = blue(pix);
      float a = alpha(pix);
      int grayscale = int(r * 0.21 + g * 0.72 + b * 0.07);
      color grayColor = color(grayscale, grayscale, grayscale);

      int leftLoc = (x - 1) + y * img.width;
      color leftPix = img.pixels[leftLoc];

      float diff = abs(brightness(grayColor) - brightness(color(int(red(leftPix) * 0.21 + green(leftPix) * 0.72 + blue(leftPix) * 0.07+ alpha(leftPix)*0.10))));
      
      if (diff > edgeThreshold) {
        ps.addImageParticle(x, y, grayColor);
      }
    
    }
      
  }
  img.updatePixels();
}

void generateParticlesForImage(PImage img) {
  img.loadPixels();
  for (int x = 1; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * img.width;
      color pix = img.pixels[loc];
      
      // Edge detection logic remains the same, adapted to use `img` parameter
      // ...
      
      float r = red(pix);
      float g = green(pix);
      float b = blue(pix);
      float a = alpha(pix);
      int grayscale = int(r * 0.21 + g * 0.72 + b * 0.07);
      color grayColor = color(grayscale, grayscale, grayscale, a);

      int leftLoc = (x - 1) + y * img.width;
      color leftPix = img.pixels[leftLoc];

      float diff = abs(brightness(grayColor) - brightness(color(int(red(leftPix) * 0.21 + green(leftPix) * 0.72 + blue(leftPix) * 0.07+ alpha(leftPix)*0.12))));
     
      if (diff > edgeThreshold) {
        ps.addImageParticle(x, y, grayColor);
       }
      
    }
  }
}
