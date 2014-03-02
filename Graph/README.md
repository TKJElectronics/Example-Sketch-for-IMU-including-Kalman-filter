#### Developed by Kristian Lauszus, TKJ Electronics 2012

The code is released under the GNU General Public License.
_________

This is the [Processing](http://processing.org/) application I made to visualize the data sent from the Arduino.

This should be used with the [ITG3205 and ADXL345](../IMU6DOF/ITG3205_ADXL345) combo or the [LPR530AL, LY530ALH and ADXL335](../IMU6DOF/LPR530AL_LY530ALH_ADXL335) I have provided.

Note that you properly need to change the serial port for it to work.

The serial port can be changed at the following line in the code:

```
arduino = new Serial(this, Serial.list()[0], 115200);
```

For more information fell free to post a question at the guide: <http://arduino.cc/forum/index.php/topic,58048.0.html> or send me an email at <kristianl@tkjelectronics.dk>.