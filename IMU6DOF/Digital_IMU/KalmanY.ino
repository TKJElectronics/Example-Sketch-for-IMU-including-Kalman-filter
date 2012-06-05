/* Kalman filter variables and constants */
const double Q_angleY = 0.001; // Process noise covariance for the accelerometer - Sw
const double Q_gyroY = 0.003; // Process noise covariance for the gyro - Sw
const double R_angleY = 0.03; // Measurement noise covariance - Sv

double angleY = 180; // The angle output from the Kalman filter
double biasY = 0; // The gyro bias calculated by the Kalman filter
double PY_00 = 0, PY_01 = 0, PY_10 = 0, PY_11 = 0;
double dtY, yY, SY;
double KY_0, KY_1;

double kalmanY(double newAngle, double newRate, double dtime) {
  // KasBot V2  -  Kalman filter module - http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1284738418
  // See also http://www.x-firm.com/?page_id=145
  // with slightly modifications by Kristian Lauszus
  // See http://academic.csuohio.edu/simond/courses/eec644/kalman.pdf and 
  // http://www.cs.unc.edu/~welch/media/pdf/kalman_intro.pdf for more information
  dtY = dtime / 1000000; // Convert from microseconds to seconds

  // Discrete Kalman filter time update equations - Time Update ("Predict")
  // Update xhat - Project the state ahead
  angleY += dtY * (newRate - biasY);

  // Update estimation error covariance - Project the error covariance ahead
  PY_00 += -dtY * (PY_10 + PY_01) + Q_angleY * dtY;
  PY_01 += -dtY * PY_11;
  PY_10 += -dtY * PY_11;
  PY_11 += +Q_gyroY * dtY;

  // Discrete Kalman filter measurement update equations - Measurement Update ("Correct")
  // Calculate Kalman gain - Compute the Kalman gain
  SY = PY_00 + R_angleY;
  KY_0 = PY_00 / SY;
  KY_1 = PY_10 / SY;

  // Calculate angle and resting rate - Update estimate with measurement zk
  yY = newAngle - angleY;
  angleY += KY_0 * yY;
  biasY += KY_1 * yY;

  // Calculate estimation error covariance - Update the error covariance
  PY_00 -= KY_0 * PY_00;
  PY_01 -= KY_0 * PY_01;
  PY_10 -= KY_1 * PY_00;
  PY_11 -= KY_1 * PY_01;

  return angleY;
}
