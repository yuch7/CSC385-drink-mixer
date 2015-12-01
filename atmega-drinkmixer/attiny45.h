/*
    Author: Eric Conner
    Project: ATtiny45
    Date: 05-31-2013
    File: ATtiny45.c
    Change Log:
        v1.1 - 07-09-2013 - Fixed Pin Numbers
        v1.2 - 08-29-2013 - Added Shift-In and Shift-Out
        v1.3 - 09-05-2013 - Added Delay
*/

#ifndef ATtiny45_H
#define ATtiny45_H

#define PB 2

#define HIGH 1
#define LOW  0

#define INPUT 0
#define OUTPUT 1
#define INPUT_PULLUP 2

#define NOT_A_PIN   0
#define NOT_A_PORT  0

// Setup Pin - Pin Number (0 ... 5), Mode (OUTPUT, INPUT, INPUT_PULLUP)
void pinMode(int pin, int mode);

// Digital Read Pin - Pin Number (0 ... 5)
int digitalRead(int pin);

// Digital Write Pin - Pin Number (0 ... 5), Value (HIGH, LOW)
void digitalWrite(int pin, int val);

// Shift In - Data Pin, Latch Pin, Clock Pin
int shiftIn(int dataPin, int latchPin, int clockPin);

// Shift Out - Data Pin, Latch Pin, Clock Pin, Value
void shiftOut(int dataPin, int latchPin, int clockPin, int val);

// Delay - (Miliseconds)
void delay(unsigned long ms);

#endif
