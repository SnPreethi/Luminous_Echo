# Luminous_Echo - A light-based musical instrument using Arduino UNO

Luminous Echo is an innovative light-based spatial instrument, utilizing Arduino Uno, photoresistors, and the ChucK musical programming language to create a unique IoT musical experience. This project combines sensor technology with musical instrument design, allowing users to interact with sound through light manipulation.

## OVERVIEW
The Luminous Echo consists of six coffee cups, each representing a note of the musical scale. At the bottom of each cup, a photoresistor is installed, wired to an Arduino Uno microcontroller. The primary function of photoresistor is to detect variations in ambient light levels, responding to subtle changes in luminosity with remarkable sensitivity and precision. As light levels fluctuate, the Arduino reads the output from each photoresistor and sends this data to a computer running ChucK, which synthesizes musical notes based on the input.

## FEATURES
* Light-based interation: Users can play the Luminous Echo by waving their arms over the cups. The light levels detected by the photoresistors determine the volume and vibrato of the produced sound.
* Arduino Uno Integration: The Arduino Uno serves as the interface between the photoresistors and the computer. It reads the data from the sensors and communicates it to the computer via serial communication.
* ChucK Musical Programming Language: ChucK is used to synthesize musical notes based on the data received from the Arduino. It provides a flexible and intuitive platform for real-time sound generation and manipulation.

## COMPONENTS USED
- Photoresistors – 6
- Arduino UNO – 1
- Breadboard – 1
- Alligator clips – 12
- Connecting wires
- Disposable coffee cups – 6
- Cardboard box – 1
- Laptop - 1

## SOFTWARE USED
* [Arduino IDE](https://www.arduino.cc/en/software)
* [Chuck](https://chuck.cs.princeton.edu/release/)

## SETUP AND CALIBRATION
To use the Luminous Echo, follow these steps:

1. Connect the Arduino UNO to the computer via USB.
2. Ensure that the correct serial port is specified in the ChucK program (MiniAudicle).
3. Calibrate the setup carefully to ensure accurate detection of light levels and optimal sound output.

## USAGE
Wave your hands over the coffee cups to trigger different notes. Experiment with varying light levels to control volume and vibrato. Each cup represents a distinct musical note, offering a diverse range of sound possibilities.

## CREDITS
This project was created by Preethi Somayajula as a demonstration of the integration of sensor technology and musical instruments. This work is inspired from the original creator - @bonniee. 
