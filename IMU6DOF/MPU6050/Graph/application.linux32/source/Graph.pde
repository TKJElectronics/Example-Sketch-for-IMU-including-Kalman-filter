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

int width = 1200;
int height = 800;

float[] gyroX = new float[width];
float[] gyroY = new float[width];

float[] accX = new float[width];
float[] accY = new float[width];

float[] compX = new float[width];
float[] compY = new float[width];

float[] kalmanX = new float[width];
float[] kalmanY = new float[width];

void setup() {  
  size(width, height);
  //println(arduino.list()); // Use this to print connected serial devices
  arduino = new Serial(this, Serial.list()[0], 115200);
  arduino.bufferUntil('\n'); // Buffer until line feed

  for (int i=0;i<width;i++) { // center all variables
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
  drawAxisX();
  //drawAxisY();
}

void serialEvent (Serial arduino) {
  // get the ASCII strings:  
  stringAccX = arduino.readStringUntil('\t');
  stringAccY = arduino.readStringUntil('\t');
  
  stringGyroX = arduino.readStringUntil('\t');
  stringGyroY = arduino.readStringUntil('\t');

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
