/* //<>// //<>//
 TUIO 1.1 Demo for Processing
 Copyright (c) 2005-2014 Martin Kaltenbrunner <martin@tuio.org>
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files
 (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge,
 publish, distribute, sublicense, and/or sell copies of the Software,
 and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;


 //these are some helper variables which are used
 //to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; // print console debug messages // htan false prin kai to alla3a
boolean callback = true; // updates only after callbacks

boolean loadImg=false;

PImage img1;// 1o zhtoumeno na emfanizei eikona
PImage img2;
PImage img3;

int imageWidth; //dhlwnw metavlhtes
int imageHeight;

float zoom=100;

//red kai tint red
float red=255;


void setup()
{
  
  // GUI setup
  noCursor();
  size(640, 480);
  noStroke();
  fill(0);

  img1 = loadImage("birds.jpg"); // 1o zhtoumeno na emfanizei eikona
  img2 = loadImage("cat.jpeg");

  imageWidth = img2.width; // orizw arxikes times tis diastaseis tis eikonas
  imageHeight = img2.height; //orizw arxikes times tis diastaseis tis eikonas

  // periodic updates
  if (!callback) {
    frameRate(60);
    loop();
  } else noLoop(); // or callback updates 

  font = createFont("Arial", 18);
  scale_factor = height/table_size;

  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);
}



// within the draw method we retrieve an ArrayList of type <TuioObject>, <TuioCursor> or <TuioBlob>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw()
{
  background(255);
  // textFont(font,18*scale_factor);
  //float obj_size = object_size*scale_factor; 
  
  
  //image(img, 0, 0, width, height); // 1o zhtoumeno na emfanizei eikona

  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i<tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i); //gia ka8e object

    if (tobj.getSymbolID()==0) {  //an o kwdikos einai to 0 fortwse auto
      translate(tobj.getScreenX(width), tobj.getScreenY(height));
      rotate (tobj.getAngle());
      image(img1, 0, 0);
    }

    if (tobj.getSymbolID()==1) {  //an o kwdikos einai to 1 fortwse auth thn eikona
      translate(tobj.getScreenX(width), tobj.getScreenY(height));
      rotate (tobj.getAngle());
      image(img2, 0, 0, imageWidth, imageHeight); 
      //emfanisou sto shmeio 0,0
      //an evaza 80, 60 ry8mizw to mege8os ths eikonas, 
      // alla gia na ginetai aytomata vazw metavlhtes imageWidth kai imageHeight
      //prepei na tis dhhlwsw epanw!!
    }

    if (loadImg){
    if (tobj.getSymbolID()==2) {  //an o kwdikos einai to 2 fortwse auth thn eikona
      //na allazw to imageWidth kai imageHeight me to rotation (zoom in kai zomm out)
      zoom = constrain(zoom + tobj.getRotationSpeed()*3, 10, 300); 
      imageWidth = int(img2.width * zoom/100);
      imageHeight = int(img2.height * zoom/100);
      // gia na metratepsw ari8mo int (epeidh edw exw int to img kai float to zoom)
      image(img2, 0, 0, imageWidth, imageHeight);
     }  
    }
    
    if (loadImg){
    if (tobj.getSymbolID()==3) {  //an o kwdikos einai to 3 fortwse auth thn eikona
      //na allazw to tint
      //tint = tint + tobj.getRotationSpeed()*3; 
      red= map(tobj.getAngle(), 0, 6.2, 255 , 0);
      tint (red,255,255);
      image(img2, 0, 0, imageWidth, imageHeight);
      // gia na metratepsw ari8mo int (epeidh edw exw int to img kai float to zoom)
     }  
    }
    
   


    /*  stroke(0);
     fill(0,0,0);
     pushMatrix();
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
     rotate(tobj.getAngle());
     rect(-obj_size/2,-obj_size/2,obj_size,obj_size);//ftiaxnei or8ogwnio
     popMatrix();
     fill(255);
     text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));//kai ftiaxnei kai ena text, dhladh ta 0,1,2...
     */
  }
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
  
  if(tobj.getSymbolID()==2);
  loadImg=true;
  
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
    +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  
  /*if (tobj.getSymbolID()=2;){
  imageWidth = img2.width; // orizw arxikes times tis diastaseis tis eikonas
  imageHeight = img2.height;} */
  
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
    +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
    +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}
