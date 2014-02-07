import processing.serial.*; 
Serial arduino; 

String stringGyroX;
String stringGyroY;

String stringAccX;
String stringAccY;

String stringCompX;
String stringCompY;

String stringKalmanX;
String stringKalmanY;

float[] gyroX = new float[600];
float[] gyroY = new float[600];

float[] accX = new float[600];
float[] accY = new float[600];

float[] compX = new float[600];
float[] compY = new float[600];

float[] kalmanX = new float[600];
float[] kalmanY = new float[600];

void setup() {  
  size(600, 400);
  println(arduino.list()); // Use this to print connected serial devices
  arduino = new Serial(this, Serial.list()[0], 115200);
  arduino.bufferUntil('\n'); // Buffer until line feed

  for (int i=0;i<600;i++) { // center all variables    
    gyroX[i] = height/2;
    gyroY[i] = height/2;
    accX[i] = height/2;
    accY[i] = height/2;
    compX[i] = height/2; 
    compY[i] = height/2; 
    kalmanX[i] = height/2; 
    kalmanY[i] = height/2;
  }
}

void draw()
{ 
  // Draw graphPaper
  background(255); // white
  for (int i = 0 ;i<=width/10;i++) {      
    stroke(200); // gray
    line((-frameCount%10)+i*10, 0, (-frameCount%10)+i*10, height);
    line(0, i*10, width, i*10);
  }

  stroke(0); // black
  for (int i = 1; i <= 3; i++)
    line(0, height/4*i, width, height/4*i); // Draw line, indicating 90 deg, 180 deg, and 270 deg

  convert();
  //drawAxisX();
  drawAxisY();
}

void serialEvent (Serial arduino) {
  // get the ASCII strings:
  stringGyroX = arduino.readStringUntil('\t');
  stringGyroY = arduino.readStringUntil('\t');

  stringAccX = arduino.readStringUntil('\t');
  stringAccY = arduino.readStringUntil('\t');

  stringCompX = arduino.readStringUntil('\t');
  stringCompY = arduino.readStringUntil('\t'); 

  stringKalmanX = arduino.readStringUntil('\t');
  stringKalmanY = arduino.readStringUntil('\t');
  
  arduino.clear(); // Clear buffer

  //printAxis(); // slows down the process and can result in error readings - use for debugging
}

void printAxis() {
  print(stringGyroX);
  print(stringGyroY);

  print(stringAccX);
  print(stringAccY);

  print(stringCompX);
  print(stringCompY);

  print(stringKalmanX);
  print(stringKalmanY);
}
