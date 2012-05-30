import processing.core.*; 

import processing.serial.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Graph extends PApplet {

 
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

public void setup() {  
  size(600, 400);
  //println(arduino.list()); // Use this to print connected serial devices
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

public void draw()
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

public void serialEvent (Serial arduino) {
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

public void printAxis() {
  print(stringGyroX);
  print(stringGyroY);

  print(stringAccX);
  print(stringAccY);

  print(stringCompX);
  print(stringCompY);

  print(stringKalmanX);
  print(stringKalmanY);
}
//convert all axis
int minAngle = 0;
int maxAngle = 360;

public void convert() {   
  /* convert the gyro x-axis */
  if (stringGyroX != null) {
    // trim off any whitespace:
    stringGyroX = trim(stringGyroX);
    // convert to an float and map to the screen height, then save in buffer:    
    gyroX[gyroX.length-1] = map(PApplet.parseFloat(stringGyroX), minAngle, maxAngle, 0, height);
  }
  
  /* convert the gyro y-axis */
  if (stringGyroY != null) {    
    // trim off any whitespace:
    stringGyroY = trim(stringGyroY);
    // convert to an float and map to the screen height, then save in buffer:   
    gyroY[gyroY.length-1] = map(PApplet.parseFloat(stringGyroY), minAngle, maxAngle, 0, height);
  }
  
  /* convert the accelerometer x-axis */
  if (stringAccX != null) {
    // trim off any whitespace:
    stringAccX = trim(stringAccX);
    // convert to an float and map to the screen height, then save in buffer:    
    accX[accX.length-1] = map(PApplet.parseFloat(stringAccX), minAngle, maxAngle, 0, height);
  }
  
  /* convert the accelerometer y-axis */
  if (stringAccY != null) {
    // trim off any whitespace:
    stringAccY = trim(stringAccY);
    // convert to an float and map to the screen height, then save in buffer:        
    accY[accY.length-1] = map(PApplet.parseFloat(stringAccY), minAngle, maxAngle, 0, height);
  }

  /* convert the complementary filter x-axis */
  if (stringCompX != null) {
    // trim off any whitespace:
    stringCompX = trim(stringCompX);
    // convert to an float and map to the screen height, then save in buffer:    
    compX[compX.length-1] = map(PApplet.parseFloat(stringCompX), minAngle, maxAngle, 0, height);
  }
  
  /* convert the complementary filter x-axis */
  if (stringCompY != null) {
    // trim off any whitespace:
    stringCompY = trim(stringCompY);
    // convert to an float and map to the screen height, then save in buffer:    
    compY[compY.length-1] = map(PApplet.parseFloat(stringCompY), minAngle, maxAngle, 0, height);
  }
  
  /* convert the kalman filter x-axis */
  if (stringKalmanX != null) {
    // trim off any whitespace:
    stringKalmanX = trim(stringKalmanX);
    // convert to an float and map to the screen height, then save in buffer:    
    kalmanX[kalmanX.length-1] = map(PApplet.parseFloat(stringKalmanX), minAngle, maxAngle, 0, height);
  }
  
  /* convert the kalman filter y-axis */
  if (stringKalmanY != null) {
    // trim off any whitespace:
    stringKalmanY = trim(stringKalmanY);
    // convert to an float and map to the screen height, then save in buffer:    
    kalmanY[kalmanY.length-1] = map(PApplet.parseFloat(stringKalmanY), minAngle, maxAngle, 0, height);
  }
}
public void drawAxisX() {
  /* draw gyro x-axis */
  noFill();
  stroke(0,0,255); // blue
  // redraw everything
  beginShape();
  for(int i = 0; i<gyroX.length;i++)
    vertex(i,gyroX[i]);
  endShape();
  // put all data one array back
  for(int i = 1; i<gyroX.length;i++)
    gyroX[i-1] = gyroX[i];   
   
  /* draw acceleromter x-axis */
  noFill();
  stroke(0,255,0); // green
  // redraw everything
  beginShape();
  for(int i = 0; i<accX.length;i++)
    vertex(i,accX[i]);  
  endShape();
  // put all data one array back
  for(int i = 1; i<accX.length;i++)
    accX[i-1] = accX[i];   
   
  /* draw complementary filter x-axis */
  noFill();
  stroke(255,255,0); // yellow
  // redraw everything
  beginShape();
  for(int i = 0; i<compX.length;i++)
    vertex(i,compX[i]);
  endShape();
  // put all data one array back
  for(int i = 1; i<compX.length;i++)
    compX[i-1] = compX[i];  
   
  /* draw kalman filter x-axis */
  noFill();
  stroke(255,0,0);//red
  // redraw everything
  beginShape();
  for(int i = 0; i<kalmanX.length;i++)
    vertex(i,kalmanX[i]);  
  endShape();
  // put all data one array back
  for(int i = 1; i<kalmanX.length;i++)
    kalmanX[i-1] = kalmanX[i];
}

public void drawAxisY() {
  /* draw gyro y-axis */
  noFill();
  stroke(0,0,255); // blue
  // redraw everything
  beginShape();
  for(int i = 0; i<gyroY.length;i++)
    vertex(i,gyroY[i]);
  endShape();
  // put all data one array back
  for(int i = 1; i<gyroY.length;i++)
   gyroY[i-1] = gyroY[i];
   
  /* draw acceleromter y-axis */
  noFill();
  stroke(0,255,0); // green
  // redraw everything
  beginShape();
  for(int i = 0; i<accY.length;i++)
    vertex(i,accY[i]);
  endShape();
  // put all data one array back
  for(int i = 1; i<accY.length;i++)
    accY[i-1] = accY[i];
   
  /* draw complementary filter y-axis */
  noFill();
  stroke(255,255,0); // yellow
  // redraw everything
  beginShape();
  for(int i = 0; i<compY.length;i++)
    vertex(i,compY[i]);
  endShape();
  // put all data one array back
  for(int i = 1; i<compY.length;i++)
    compY[i-1] = compY[i];
  
  /* draw kalman filter y-axis */
  noFill();
  stroke(255,0,0); // red
  // redraw everything
  beginShape();
  for(int i = 0; i<kalmanY.length;i++)
    vertex(i,kalmanY[i]);
  endShape();
  //put all data one array back
  for(int i = 1; i<kalmanY.length;i++)
    kalmanY[i-1] = kalmanY[i];
}    

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "Graph" });
  }
}
