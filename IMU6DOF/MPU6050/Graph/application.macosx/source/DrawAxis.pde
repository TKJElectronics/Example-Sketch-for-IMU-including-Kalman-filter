void drawAxisX() {
  /* draw gyro x-axis */
  noFill();
  stroke(255,255,0); // yellow
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
  stroke(0,0,255); // blue
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

void drawAxisY() {
  /* draw gyro y-axis */
  noFill();
  stroke(255,255,0); // yellow
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
  stroke(0,0,255); // blue
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

