/*****************************************************************

DATA OBJECT - RISD Wintersession 2017

Pixels as data: simple image processing

This sketch will allow you to load an image (typically kept in the 
"data" folder) and play, alter, and bend the pixels using any of the
tools found in Processing.  

As the sketch is currently, the sketch is "tracking" two colors, 
but you may add as many as you wish, using whatever parameters you
find convenient.  

It will also allow you to save a frame from the sketch in the form
of a jpg by pressing 's'.

Begin by making some modifications to the image processing para-
meters and trying some new images, then build the sketch into
something new.  

*****************************************************************/

// Global variables up here (before setup): these are accessible to the entire sketch

// Declaring the image we'll be using (set the file name below)
PImage pic;

// This will be the first color that we'll be tracking -- 
// below, we'll search for pixels that are close to it.  
// maxColorDifference is the "distance" at which we'll accept colors
color trackColor_0=color(255); 
int trackR_0=0, trackG_0=0, trackB_0=0, maxColorDifference_0 = 40;

// The second color we're tracking
color trackColor_1=color(128, 50, 50);
int trackR_1=0, trackG_1=0, trackB_1=0, maxColorDifference_1 = 60;

void setup()  {
  fullScreen();
  frameRate(30);
    
  // You'll have to make sure the name of your image matches this
  pic = loadImage("0.jpg");
}
  
void draw()  {
  // First we'll render the picture to fill the entire screen . . .
  image(pic, 0, 0, width, height);
  // . . . then we'll load all the pixels
  loadPixels();
  
  // counts where we are in the array of pixels
  int counter = 0; 
  
  //The first loop corresponds to height/y
  for(int j = 0; j < height; j++)  {
    // The second loop corresponds to width/x
    for(int i = 0; i < width; i++)  {
      // Grab the color at that position in the array, and bring the RGB values into the variables
      // r, g, and b
      color c = pixels[counter];
      int r = (c >> 16) & 0xff, g = (c >> 8) & 0xff, b = c & 0xff;
      
      // Here I create another set of variables (_r, _g, and _b, so that we can use track the colors
      // without altering the original values
      int _r = r, _g = g, _b = b;
      
      // ****Here's the actual image processing****
      // If the color is close enough to the color we're tracking, then alter the _r, _g, _b values
      // **This is one simple example -- try new things!** 
      float colorDifference_0 = dist(r, g, b, trackR_0, trackG_0, trackB_0);
      if(colorDifference_0 < maxColorDifference_0 && j%2 == 0)  {
        _r += 150;
        _g -= 200;
        _b /= 5;
      }
      
      // Image processing for the second color we're tracking
      float colorDifference_1 = dist(r, g, b, trackR_1, trackG_1, trackB_1);
      if((colorDifference_1 < maxColorDifference_1 && counter%2 == 0) || j%16 == 0)  {
        _r *= 3;
        _g = 0;
        _b += 34;
      } 
      
      // update the pixels, advance where we are in the array
      pixels[counter] = color(_r, _g, _b);
      counter++;
    }
  }
  // If you don't update the pixels, they won't display
  updatePixels();
}

// KeyPressed() is called each and every time you press a key.  
// That key is stored in a variable ("key")
void keyPressed()  {
  if(key == '1')  {
    // Get the color of the image at the point where your mouse is:
    trackColor_0 = get(mouseX, mouseY);
    
    // Copy the RGB value so that you can track it
    trackR_0 = (trackColor_0 >> 16) & 0xff; 
    trackG_0 = (trackColor_0 >> 8) & 0xff;
    trackB_0 = trackColor_0 & 0xff;
  }  else if(key == '2')  {
    // Same thing for another color
    trackColor_1 = get(mouseX, mouseY);
    trackR_1 = (trackColor_1 >> 16) & 0xff; 
    trackG_1 = (trackColor_1 >> 8) & 0xff;
    trackB_1 = trackColor_1 & 0xff;
  }  else if(key == 's')  {
    // Easy way of saving stills from your sketch!  
    saveFrame("save/ImageProcessing_####.jpg");
  }
}