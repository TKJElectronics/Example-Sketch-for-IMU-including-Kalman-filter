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

#include "Kalman.h" // Source: https://github.com/TKJElectronics/KalmanFilter

Kalman kalmanX;
Kalman kalmanY;

#define gX A0
#define gY A1
#define gZ A2

#define aX A3
#define aY A4
#define aZ A5

double zeroValue[6] = { 0 }; // gyroX, gyroY, gyroZ, accX, accY, accZ

/* All the angles start at 180 degrees */
double gyroXangle = 180;
double gyroYangle = 180;
double gyroZangle = 180;

// Complimentary filter
double compAngleX = 180;
double compAngleY = 180;

// Used for timing
unsigned long timer;

void setup() {
  analogReference(EXTERNAL); // 3.3V
  Serial.begin(115200);
  delay(100);//wait for the sensor to get ready

  // Calibrate all sensors in horizontal position
  for (uint8_t i = 0; i < 100; i++) { // Take the average of 100 readings
    zeroValue[0] += analogRead(gX);
    zeroValue[1] += analogRead(gY);
    zeroValue[2] += analogRead(gZ);
    zeroValue[3] += analogRead(aX);
    zeroValue[4] += analogRead(aY);
    zeroValue[5] += analogRead(aZ);
    delay(10);
  }
  zeroValue[0] /= 100;
  zeroValue[1] /= 100;
  zeroValue[2] /= 100;
  zeroValue[3] /= 100;
  zeroValue[4] /= 100;
  zeroValue[5] /= 100;
  zeroValue[5] -= 102.3; // Z value is -1g when facing upwards - Sensitivity = 0.33/3.3*1023=102.3

  kalmanX.setAngle(180); // Set starting angle
  kalmanY.setAngle(180);
  timer = micros(); // start timing
}

void loop() {
  double gyroXrate = -((analogRead(gX) - zeroValue[0]) / 1.0323); // (gyroXadc-gryoZeroX)/Sensitivity - in quids - Sensitivity = 0.00333/3.3*1023=1.0323
  gyroXangle += gyroXrate * ((double)(micros() - timer) / 1000000); // Without any filter

  double gyroYrate = -((analogRead(gY) - zeroValue[1]) / 1.0323);
  gyroYangle += gyroYrate * ((double)(micros() - timer) / 1000000);

  /*
  double gyroZrate = -((analogRead(gZ)-zeroValue[2])/1.0323);
  gyroZangle += gyroZrate*((double)(micros()-timer)/1000000);
  Serial.println(gyroZangle); // This is the yaw
  */

  double accXval = (double)analogRead(aX) - zeroValue[3];
  double accYval = (double)analogRead(aY) - zeroValue[4];
  double accZval = (double)analogRead(aZ) - zeroValue[5];

  // Convert to 360 degrees resolution
  // atan2 outputs the value of -π to π (radians) - see http://en.wikipedia.org/wiki/Atan2
  // We are then convert it to 0 to 2π and then from radians to degrees
  double accXangle = (atan2(accXval, accZval) + PI) * RAD_TO_DEG;
  double accYangle = (atan2(accYval, accZval) + PI) * RAD_TO_DEG;

  /* You might have to tune the filters to get the best values */
  compAngleX = (0.98 * (compAngleX + (gyroXrate * (double)(micros() - timer) / 1000000))) + (0.02 * (accXangle));
  compAngleY = (0.98 * (compAngleY + (gyroYrate * (double)(micros() - timer) / 1000000))) + (0.02 * (accYangle));
  double xAngle = kalmanX.getAngle(accXangle, gyroXrate, (double)(micros() - timer));
  double yAngle = kalmanY.getAngle(accYangle, gyroYrate, (double)(micros() - timer));

  timer = micros(); // reset timing

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
