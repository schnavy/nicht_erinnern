import processing.video.*;
import gab.opencv.*;
import java.awt.*;


PImage img;




PFont font;

PImage subimg[];
String[] subs = {
  "Ich kann mich nicht erinnern", 
  "Du darfst mich nicht sehen", 
  "Ich möchte es nicht wissen", 
};

int randomNum = int(random(subs.length));

Capture video;
OpenCV opencv;

int r = 10;

int n = 0;
int sfactor = 4;
int screenw = 1280/sfactor;
int screenh = 720/sfactor;
boolean toggle = false;



void setup() {

  video = new Capture(this, screenw, screenh);
  opencv = new OpenCV(this, screenw, screenh);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  font = loadFont("NeueMontreal-Italic-48.vlw");
  img = loadImage("../assets/blur.png");
  subimg = new PImage[6];

  
 
  subimg[0] = loadImage("../assets/sub_03.png");
  subimg[1] = loadImage("../assets/sub-dist_03.png");
  subimg[2] = loadImage("../assets/sub_06.png");
  subimg[3] = loadImage("../assets/sub-dist_06.png");
  subimg[4] = loadImage("../assets/sub_09.png");
  subimg[5] = loadImage("../assets/sub-dist_09.png");


  rectMode(CENTER);

//  fullScreen();
  size(1080, 720);
  frameRate(12);

  video.start();
}


void draw() {
  if(n%10==0){
  println(frameRate);
}
  noFill();
  noStroke();
  strokeWeight(3);


  opencv.loadImage(video);



  Rectangle[] faces = opencv.detect();

  if (faces.length != 0) {

    scale(sfactor);

    image(video, 0, 0, screenw, screenh);

   // println(frameRate);

    for (int i = 0; i < faces.length; i++) {
      int x = ((faces[i].x-r)*sfactor);
      int y = ((faces[i].y-r-10)*sfactor);
      int w = (faces[i].width+r*2)*sfactor;
      int h = ((faces[i].height+r*2+10)*sfactor);

      scale(1/float(sfactor));

      PImage face = get(x, y, w, h);

      if (toggle) {
        int raster = 10;

        for (int j = 0; j < w; j+=w/raster) {
          for (int k = 0; k < h; k+=w/raster) {

            color c = face.pixels[j+k*w];
            fill(c);
            stroke(c);

            rect(x+j, y+k, w/raster, w/raster);
            r = 10;
          }
        }
      } else if (toggle==false) {
        tint(240, 245, 255); 
        imageMode(CENTER);
        image(img, x+w/2, y+h/2, w*2.5, w*2.5);
        imageMode(CORNER);
      } 
      //else if (toggle==2) {
      //  int raster = 100;

      //  for (int j = 0; j < w; j+=w/raster) {
      //    for (int k = 0; k < h; k+=w/raster) {
      //      float d = dist(x+j, y+k, x+w/2, y+h/2 ) ;
      //      int c = int(map(d, 0, w/2, 400, 0));
      //      fill(130, 130, 130, c);
      //      rect(x+j, y+k, w/raster, w/raster);
      //      r = 20;
      //    }
      //  }
      //}
      
  fill(0);
  textAlign(CENTER);
  textFont(font);
  
  imageMode(CENTER);
  image(subimg[randomNum], width/2, height-100);
  imageMode(CORNER);

  //int kontur = 2;
  //int textY = height-70;
  //String subt = subs[randomNum];  
  //  text(subt, width/2+kontur, textY);
  //  text(subt, width/2, textY+kontur);
  //  text(subt, width/2-kontur, textY);
  //  text(subt, width/2, textY-kontur);
  //  text(subt, width/2-kontur, textY-kontur);
  //  text(subt, width/2+kontur, textY+kontur);
  
  //fill(255, 255, 0);
  //text(subt, width/2, textY);

      scale(sfactor);
    }
 
   }else{
     
     toggle = !toggle; 
    randomNum = int(random(subimg.length));

         if (n%10==0) {
           imageMode(CENTER);
           float noiX = (noise(n)+0.5);
           float noiY = (noise(n+1)+0.5);
        image(img, width/2*noiX*2, height/2*noiY*2 , 600 , 600);
        imageMode(CORNER);
            
  }
   
   }



  n++;


  //if (n%100==0) {
  //  randomNum = int(random(subs.length));

  //}
  
  
  
  
  
}

void captureEvent(Capture c) {
  c.read();
}
