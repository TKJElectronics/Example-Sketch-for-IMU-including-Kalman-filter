/* Copyright (C) 2012 Kristian Lauszus, TKJ Electronics. All rights reserved.

 This software may be distributed and modified under the terms of the GNU
 General Public License version 2 (GPL2) as published by the Free Software
 Foundation and appearing in the file GPL2.TXT included in the packaging of
 this file. Please note that GPL2 Section 2[b] requires that all works based
 on this software must also be made publicly available under the terms of
 the GPL2 ("Copyleft").

 Contact information
 -------------------

 Kristian Lauszus, TKJ Electronics
 Web      :  http://www.tkjelectronics.com
 e-mail   :  kristianl@tkjelectronics.com
 */

#include <Wire.h>
#include "Kalman.h" // Source: https://github.com/TKJElectronics/KalmanFilter

Kalman kalmanX;
Kalman kalmanY;

#define gyroAddress 0x68
#define adxlAddress 0x53

double zeroValue[5] = { -200, 44, 660, 52.3, -18.5}; // Found by experimenting

/* All the angles start at 180 degrees */
double gyroXangle = 180;
double gyroYangle = 180;

double compAngleX = 180;
double compAngleY = 180;

unsigned long timer;

uint8_t buffer[2]; // I2C buffer

void setup() {
  Serial.begin(115200);
  Wire.begin();

  i2cWrite(adxlAddress, 0x31, 0x09); // Full resolution mode
  i2cWrite(adxlAddress, 0x2D, 0x08); // Setup ADXL345 for constant measurement mode

  i2cWrite(gyroAddress, 0x16, 0x1A); // this puts your gyro at +-2000deg/sec  and 98Hz Low pass filter
  i2cWrite(gyroAddress, 0x15, 0x09); // this sets your gyro at 100Hz sample rate

  kalmanX.setAngle(180); // Set starting angle
  kalmanY.setAngle(180);
  timer = micros();
}

void loop() {
  double gyroXrate = -(((double)readGyroX() - zeroValue[3]) / 14.375);
  gyroXangle += gyroXrate * ((double)(micros() - timer) / 1000000); // Without any filter

  double gyroYrate = (((double)readGyroY() - zeroValue[4]) / 14.375);
  gyroYangle += gyroYrate * ((double)(micros() - timer) / 1000000); // Without any filter

  double accXangle = getXangle();
  double accYangle = getYangle();

  compAngleX = (0.93 * (compAngleX + (gyroXrate * (double)(micros() - timer) / 1000000))) + (0.07 * accXangle);
  compAngleY = (0.93 * (compAngleY + (gyroYrate * (double)(micros() - timer) / 1000000))) + (0.07 * accYangle);

  double xAngle = kalmanX.getAngle(accXangle, gyroXrate, (double)(micros() - timer)); // calculate the angle using a Kalman filter
  double yAngle = kalmanY.getAngle(accYangle, gyroYrate, (double)(micros() - timer)); // calculate the angle using a Kalman filter

  timer = micros();

  /* print data to processing */
  Serial.print(gyroXangle); Serial.print("\t");
  Serial.print(gyroYangle); Serial.print("\t");

  Serial.print(accXangle); Serial.print("\t");
  Serial.print(accYangle); Serial.print("\t");

  Serial.print(compAngleX); Serial.print("\t");
  Serial.print(compAngleY); Serial.print("\t");

  Serial.print(xAngle); Serial.print("\t");
  Serial.print(yAngle); Serial.print("\t");

  Serial.print("\n");

  delay(10);
}
void i2cWrite(uint8_t address, uint8_t registerAddress, uint8_t data) {
  Wire.beginTransmission(address);
  Wire.write(registerAddress);
  Wire.write(data);
  Wire.endTransmission();
}
uint8_t* i2cRead(uint8_t address, uint8_t registerAddress, uint8_t nbytes) {
  Wire.beginTransmission(address);
  Wire.write(registerAddress);
  Wire.endTransmission();
  Wire.beginTransmission(address);
  Wire.requestFrom(address, nbytes);
  for (uint8_t i = 0; i < nbytes; i++)
    buffer[i] = Wire.read();
  Wire.endTransmission();
  return buffer;
}
int readGyroX() { // This really measures the y-axis of the gyro
  uint8_t* data = i2cRead(gyroAddress, 0x1F, 2);
  return ((data[0] << 8) | data[1]);
}
int readGyroY() { // This really measures the x-axis of the gyro
  uint8_t* data = i2cRead(gyroAddress, 0x1D, 2);
  return ((data[0] << 8) | data[1]);
}
double getXangle() {
  double accXval = (double)readAccX() - zeroValue[0];
  double accZval = (double)readAccZ() - zeroValue[2];
  double angle = (atan2(accXval, accZval) + PI) * RAD_TO_DEG;
  return angle;
}
double getYangle() {
  double accYval = (double)readAccY() - zeroValue[1];
  double accZval = (double)readAccZ() - zeroValue[2];
  double angle = (atan2(accYval, accZval) + PI) * RAD_TO_DEG;
  return angle;
}
int readAccX() {
  uint8_t* data = i2cRead(adxlAddress, 0x32, 2);
  return (data[0] | (data[1] << 8));
}
int readAccY() {
  uint8_t* data = i2cRead(adxlAddress, 0x34, 2);
  return (data[0] | (data[1] << 8));
}
int readAccZ() {
  uint8_t* data = i2cRead(adxlAddress, 0x36, 2);
  return (data[0] | (data[1] << 8));
}
