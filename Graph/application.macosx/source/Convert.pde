//convert all axis
int minAngle = 0;
int maxAngle = 360;

void convert() {   
  /* convert the gyro x-axis */
  if (stringGyroX != null) {
    // trim off any whitespace:
    stringGyroX = trim(stringGyroX);
    // convert to an float and map to the screen height, then save in buffer:    
    gyroX[gyroX.length-1] = map(float(stringGyroX), minAngle, maxAngle, 0, height);
  }
  
  /* convert the gyro y-axis */
  if (stringGyroY != null) {    
    // trim off any whitespace:
    stringGyroY = trim(stringGyroY);
    // convert to an float and map to the screen height, then save in buffer:   
    gyroY[gyroY.length-1] = map(float(stringGyroY), minAngle, maxAngle, 0, height);
  }
  
  /* convert the accelerometer x-axis */
  if (stringAccX != null) {
    // trim off any whitespace:
    stringAccX = trim(stringAccX);
    // convert to an float and map to the screen height, then save in buffer:    
    accX[accX.length-1] = map(float(stringAccX), minAngle, maxAngle, 0, height);
  }
  
  /* convert the accelerometer y-axis */
  if (stringAccY != null) {
    // trim off any whitespace:
    stringAccY = trim(stringAccY);
    // convert to an float and map to the screen height, then save in buffer:        
    accY[accY.length-1] = map(float(stringAccY), minAngle, maxAngle, 0, height);
  }

  /* convert the complementary filter x-axis */
  if (stringCompX != null) {
    // trim off any whitespace:
    stringCompX = trim(stringCompX);
    // convert to an float and map to the screen height, then save in buffer:    
    compX[compX.length-1] = map(float(stringCompX), minAngle, maxAngle, 0, height);
  }
  
  /* convert the complementary filter x-axis */
  if (stringCompY != null) {
    // trim off any whitespace:
    stringCompY = trim(stringCompY);
    // convert to an float and map to the screen height, then save in buffer:    
    compY[compY.length-1] = map(float(stringCompY), minAngle, maxAngle, 0, height);
  }
  
  /* convert the kalman filter x-axis */
  if (stringKalmanX != null) {
    // trim off any whitespace:
    stringKalmanX = trim(stringKalmanX);
    // convert to an float and map to the screen height, then save in buffer:    
    kalmanX[kalmanX.length-1] = map(float(stringKalmanX), minAngle, maxAngle, 0, height);
  }
  
  /* convert the kalman filter y-axis */
  if (stringKalmanY != null) {
    // trim off any whitespace:
    stringKalmanY = trim(stringKalmanY);
    // convert to an float and map to the screen height, then save in buffer:    
    kalmanY[kalmanY.length-1] = map(float(stringKalmanY), minAngle, maxAngle, 0, height);
  }
}
