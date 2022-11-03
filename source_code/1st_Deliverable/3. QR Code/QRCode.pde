import qrcodeprocessing.*;


Decoder decoder;
PImage img;

void setup() {
   size(720, 740);
  img = loadImage("websiteplanet-qr.jpeg");
  decoder = new Decoder(this);
decoder.decodeImage(img);

}

void draw() {
  background(0);
  image(img, 0, 0, width, height);
}


void decoderEvent(Decoder decoder) {

  String statusMsg = decoder.getDecodedString(); 
  println(statusMsg);
  link("https://github.com/Panagiota98");
}



/*PImage img; 

void setup() {
  size(720, 740);
  img = loadImage("Giota.jpg");
}

void draw() {
  background(0);
  image(img, 0, 0, width, height);
}*/
