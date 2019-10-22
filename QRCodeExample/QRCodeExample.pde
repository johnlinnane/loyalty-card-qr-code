import http.requests.*; //<>//
import processing.video.*;

String decodedText;
Capture webCamera;


int stampNumber = 0;

final float GAP = 30;
final float SIZECUP = 100;
final int COLUMN = 3;

PImage loyaltyCard;
PImage [] fullCup = new PImage [9];
PImage [][] emptyCup = new PImage [3][3];

void setup() {
  size(500, 1200);
  startCamera();
  loyaltyCard = loadImage("loyaltyCard.png");  
  for(int i = 0; i < 9; i++){
    fullCup[i] = loadImage("fullCup.png");
  }          
  for(int j = 0; j < 3; j++){
    for(int i = 0; i < 3; i++){
      emptyCup[i][j] = loadImage("emptyCup.png");
    }        
  }
}

void draw() {
  background(255);

  if (webCamera.available() == true) {
    webCamera.read();
  }

  image(webCamera, 0, 0); 
  image(loyaltyCard, 0, height/5, width, height/3*2);
  createCups();
  fillCupsTo(stampNumber);
}

void createCups(){
  for(int j = 0; j < 3; j++){
    for(int i = 0; i < 3; i++){
      image(emptyCup[i][j], 40 + GAP * (i + 1) + SIZECUP * i, (height / 2 - 20) + GAP * j + SIZECUP * j, SIZECUP, SIZECUP);
    }        
  }
}

void decodeQRCode(PImage img) {
  BarCodeReader qrReader = new BarCodeReader(img);
  println(qrReader.decode());  
  
  if (qrReader.decode() != "Error: No Barcode") {                           // if captured a qrcode
    JSONObject json = parseJSONObject(qrReader.decode());                   // initialize a json obj 
    if (json == null) {
      println("Could not parse JSON");
    } else {
      String id = json.getString("ID");                                     // parse json and save ID info in to id
      println(id);   
                                                                            // then send +1 request to server with id
      GetRequest update = new GetRequest("https://cs1.ucc.ie/~iw2/voucher/" + id);
      update.send();    
      
      if (int(update.getContent()) >= 10) {                                 // after getting 9 stemps, reset
        GetRequest reset = new GetRequest("https://cs1.ucc.ie/~iw2/reset/" + id);
        reset.send();        
      }
      
      println(update.getContent());                                         // for testing
      this.stampNumber = int(update.getContent());                               // convay this value back to global
    }    //https://cs1.ucc.ie/~iw2/reset/    
  }   
}

void fillCupsTo(int num) {
  float x = 70, y = (height / 2 - 20);
  if(num == 10) {
    println("You have won one free cup of coffee.");
    createCups();
    return;
  }
  for(int i = 0; i < num; i++) {
    if(i != 0 && i % COLUMN == 0) {
      y += GAP + SIZECUP; x = 70; 
    }
    image(fullCup[i], x, y, SIZECUP, SIZECUP);
    x += GAP + SIZECUP;    
  }  
}


////////////////////////////////////////////////////////////////////

void keyPressed() {
  if (key == ' ') {
    PImage scr = get(0, 0, width, height);
    decodeQRCode(scr);
  }
}

void startCamera() {
  String[] cameras = Capture.list();

  if (cameras.length != 0) {
    webCamera = new Capture(this, cameras[0]);
    webCamera.start();
  }
}
