import processing.serial.*;
Serial serial;

String rollRaw, pitchRaw, yawRaw;
String gyroX, gyroY, gyroZ;
String compX, compY, compZ;
String kalmanX, kalmanY, kalmanZ;

float roll, pitch, yaw;
float rollStart, pitchStart, yawStart;

boolean firstValue = true;
boolean drawValues  = false;

final int width = 600;
final int height = 600;

float x0 = width/2, y0 = height/2, z0 = 0;

final float radius = 250;

void setup() {
  size(width, height, P3D);

  for (int i = 0; i < Serial.list().length; i++)
    println("[" + i + "]: " +  Serial.list()[i]); // Use this to print all serial devices

  try {
    serial = new Serial(this, Serial.list()[10], 115200); // Set this to your serial port obtained using the line above
    serial.bufferUntil('\n'); // Buffer until line feed
  } catch(Exception e) {
    println("Please select a valid COM-port!");
    exit();
  }

  drawPlane(); // Draw plane at startup
}

void draw() {
  if (drawValues) { // Draw plane
    drawValues = false;
    drawPlane();
  }
}

void drawPlane() {
  background(255);
  lights();

  stroke(255, 0, 0);
  float alpha1 = roll;
  float beta1 = yaw; 
  float y1 = y0 + sin(radians(alpha1)) * cos(radians(beta1)) * radius;
  float z1 = z0 - sin(radians(beta1)) * radius;
  float x1 = x0 + cos(radians(alpha1)) * cos(radians(beta1)) * radius;
  line(x0, y0, z0, x1, y1, z1);
  //print((x1 - x0) / radius); print('\t'); print((y1 - y0) / radius); print('\t'); println((z1 - z0) / radius);

  stroke(0, 255, 0);
  float alpha2 = pitch;
  float beta2 = roll; 
  float z2 = z0 + sin(radians(alpha2)) * cos(radians(beta2)) * radius;
  float x2 = x0 + sin(radians(beta2)) * radius;
  float y2 = y0 - cos(radians(alpha2)) * cos(radians(beta2)) * radius;
  line(x0, y0, z0, x2, y2, z2);
  //print((x2 - x0) / radius); print('\t'); print((y2 - y0) / radius); print('\t'); println((z2 - z0) / radius);

  stroke(0, 0, 255);
  float alpha3 = yaw;
  float beta3 = pitch; 
  float x3 = x0 - sin(radians(alpha3)) * cos(radians(beta3)) * radius;
  float y3 = y0 + sin(radians(beta3)) * radius;
  float z3 = z0 + cos(radians(alpha3)) * cos(radians(beta3)) * radius;
  line(x0, y0, z0, x3, y3, z3);
  //print((x3 - x0) / radius); print('\t'); print((y3 - y0) / radius); print('\t'); println((z3 - z0) / radius); 

/*
  translate(width/2, height/2, 0);
  float radRoll = radians(roll);
  float radPitch = radians(pitch);
  float radYaw = radians(yaw);
  rotateX(-radPitch * cos(radYaw) - radRoll * sin(radYaw) + HALF_PI);
  rotateY(-radPitch * sin(radYaw) + radRoll * cos(radYaw));
  rotateZ(radYaw * cos(radPitch) + radRoll * sin(radPitch));
  box(200, 200, 30);
  
  print(roll);
  print(',');
  print(pitch);
  print(',');
  print(yaw);

  print('\t');
  
  print(radRoll);
  print(',');
  print(radPitch);
  print(',');
  println(radYaw);
*/
}

void serialEvent (Serial serial) {
  String[] input = trim(split(serial.readString(), '\t'));
  if (input.length != 15) {
    println("Wrong length: " + input.length);
    return;
  }

  // Get the ASCII strings:
  rollRaw = input[0];
  gyroX = input[1];
  compX = input[2];
  kalmanX = input[3];

  // Ignore extra tab

  pitchRaw = input[5];
  gyroY = input[6];
  compY = input[7];
  kalmanY = input[8];

  // Ignore extra tab

  yawRaw = input[10];
  gyroZ = input[11];
  compZ = input[12];
  kalmanZ = input[13];

  roll = float(kalmanX); // Show the Kalman values
  pitch = float(kalmanY);
  yaw = float(kalmanZ);

  if (firstValue) {
    rollStart = roll;
    pitchStart = pitch;
    yawStart = yaw;
    firstValue  = false;
  }
  
  roll -= rollStart;
  pitch -= pitchStart;
  yaw -= yawStart;

  serial.clear(); // Clear buffer
  drawValues = true; // Draw the plane

  //printValues(); // Used for debugging
}

void keyPressed() {
  if (key == 'r')
    firstValue = true;
}

void printValues() {
  print(rollRaw);
  print(',');
  print(gyroX);
  print(',');
  print(compX);
  print(',');
  print(kalmanX);

  print('\t');

  print(pitchRaw);
  print(',');
  print(gyroY);
  print(',');
  print(compY);
  print(',');
  print(kalmanY);

  print('\t');

  print(yawRaw);
  print(',');
  print(gyroZ);
  print(',');
  print(compZ);
  print(',');
  print(kalmanZ);

  println();
}
