#### Developed by Kristian Lauszus, TKJ Electronics 2012

The code is released under the GNU General Public License.
_________

This is the firmware for the my guide at the Arduino forum: <http://arduino.cc/forum/index.php/topic,58048.0.html>, including a Processing application (see the [Graph](Graph) directory) to visualize the data sent from the Arduino.

There is currently examples for the following IMU's:

* "IMU Analog Combo Board Razor - 6DOF Ultra-Thin IMU" from Sparkfun: <http://www.sparkfun.com/products/10010>
* Digital IMU featuring a ITG3205 and a ADXL345
* MPU-6050 - 3-axis gyroscope and 3-axis accelerometer
* MPU-6050 and HMC5883L - 3-axis gyroscope, 3-axis accelerometer and 3-axis magnetometer

The Kalman filter used in all the examples can be found at my other repository: <https://github.com/TKJElectronics/KalmanFilter>.

Note that I update the [MPU-6050](IMU6DOF/MPU6050/MPU6050.ino) code more frequently, so you should take a look at that even if you are using one of the other sensors.

For more information fell free to post a question at the guide: <http://arduino.cc/forum/index.php/topic,58048.0.html> or send me an email at <kristianl@tkjelectronics.dk>.