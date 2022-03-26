import processing.video.*;

// Obamathon
// https://github.com/ITPNYU/Obamathon
// YouTube video tutorial: https://youtu.be/nnlAH1zDBDE

// Source Obama image
//PImage obama;
Capture obama;
// Resize it
PImage smaller;
// Giant array of images
PImage[] allImages;
// Corresponding brightness value
float[] brightness;
float[] redness;
float[] greenness;
float[] blueness;
float[][][] colorArray;
float[][][] white;
// Images by brightness
PImage[] brightImages;
PImage[][][] chosenImages;

Capture video;

// Size of each "cell"
int scl = 30;
int w, h;

void setup() {
  size (1080,720);
  //obama = loadImage("1200px-President_Barack_Obama.jpeg");
    //obama = loadImage("cat.jpeg");
    //obama = loadImage("alicia2.JPG");
    //obama = loadImage("monkeyjpg.jpg");
    
    obama = new Capture(this,width,height);
    obama.start();
   
   
   

  // Find all the images
  File[] files = listFiles(sketchPath("Gems"));
  //allImages = new PImage[files.length-1];
  // Use a smaller amount just for testing
  allImages = new PImage[files.length];
  // Need brightness average for each image
  brightness = new float[allImages.length];
  
  redness = new float[allImages.length];
  greenness = new float[allImages.length];
  blueness = new float[allImages.length];

  // Only 256 brightness values
  brightImages = new PImage[256];
  chosenImages = new PImage[256][256][256];

  // Deal with all the images
  for (int i = 0; i < allImages.length; i++) {

    // What's the filename?
    // Should really check to see if it's a JPG
    // Starting at +1 to ignore .DS_Store on Mac
    String filename = files[i].toString();

    // Load the image
    PImage img = loadImage(filename);

    // Shrink it down
    allImages[i] = createImage(scl, scl, RGB);
    allImages[i].copy(img, 0, 0, img.width, img.height, 0, 0, scl, scl);
    allImages[i].loadPixels();

    // Calculate average brightness
    float avg = 0;
    
    float avgR = 0;
    float avgG = 0;
    float avgB = 0;
    
    float missedPixels = 0;
    
    for (int j = 0; j < allImages[i].pixels.length; j++) {
      float b =  brightness(allImages[i].pixels[j]);
      
      float red =  red(allImages[i].pixels[j]);
      float green =  green(allImages[i].pixels[j]);
      float blue =  blue(allImages[i].pixels[j]);
      
    
      //if(red > 250 && green > 250 && blue >250){
      //  missedPixels++;
      //}else{
        
       avgR += red;
        avgG += green;
         avgB += blue;
      
      avg += b;
     // }
    }
    avg /= allImages[i].pixels.length;
    
    avgR /= allImages[i].pixels.length-missedPixels;
    avgG /= allImages[i].pixels.length-missedPixels;
    avgB /= allImages[i].pixels.length-missedPixels;


    brightness[i] = avg;
    
    redness[i] = avgR;
    greenness[i] = avgG;
    blueness[i] = avgB;
  }

  // Find the closest image for each brightness value
  for (int r = 0; r < brightImages.length; r++) {
      for (int g = 0; g < brightImages.length; g++) {
          for (int b = 0; b < brightImages.length; b++) {
            
    float record = 768;
    
    for (int j = 0; j < brightness.length; j++) {
      float diff = abs(r - redness[j])+abs(g - greenness[j])+abs(b - blueness[j]);
      if (diff < record) {
        record = diff;
        //brightImages[i] = allImages[j];
        chosenImages[r][g][b] = allImages[j];
        
      }
    }
          }
      }
  }

  // how many cols and rows
  w = obama.width/scl;
  h = obama.height/scl;
 
  //smaller = createImage(w, h, RGB);
  //smaller.copy(obama, 0, 0, obama.width, obama.height, 0, 0, w, h);
}

void doGems(){

 // obama.read();
  // how many cols and rows

}


//void captureEvent(Capture obama){
//  obama.read();
  
//    w = obama.width/scl;
//  h = obama.height/scl;
 
//  smaller = createImage(w, h, RGB);
//  smaller.copy(obama, 0, 0, obama.width, obama.height, 0, 0, w, h);
//}

//void mousePressed(Capture video){
//  video.read();
//}

void draw() {
  
  int scl = (mouseX/20)+1;
  
 
  
  if (obama.available()) {
    obama.read();
     w = obama.width/scl;
  h = obama.height/scl;
    smaller = createImage(w, h, RGB);
    smaller.copy(obama, 0, 0, obama.width, obama.height, 0, 0, w, h);
  
  }
  
  background(0);
 // smaller.loadPixels();
  // Columns and rows
  for (int x =0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      // Draw an image with equivalent brightness to source pixel
      int index = x + y * w;
      color c = smaller.pixels[index];
      int imageIndex = int(brightness(c));
      
      int rInd = int(red(c));
      int gInd = int(green(c));
      int bInd = int(blue(c));
      
       //fill(rInd,gInd,bInd);
       //noStroke();
       //rect(x*scl, y*scl, scl, scl);
       
      image(chosenImages[rInd][gInd][bInd], x*scl, y*scl, scl, scl);
    }
  }
  //noLoop();
}
