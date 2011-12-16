#include <Bounce.h>

#define encoder0PinA  2
#define encoder0PinB  4

Bounce bouncerA = Bounce(encoder0PinA, 5);
Bounce bouncerB = Bounce(encoder0PinB, 5);

//pad identification bytes
byte A01 = B000;
byte A02 = B001;
byte A03 = B010;
byte A04 = B011;

//mic identification bytes
byte A05 = B100;
byte A06 = B101;
byte A07 = B110;
byte A08 = B111;

int A01Value = 0;
int A02Value;
int A03Value;
int A04Value;
int A05Value;

int state, prevstate = 0, count = 0;
int nextEncoderState[4] = { 2, 0, 3, 1 };
int prevEncoderState[4] = { 1, 3, 0, 2 };


void setup() {
  pinMode(encoder0PinA, INPUT); 
  digitalWrite(encoder0PinA, HIGH);       // turn on pullup resistor
  pinMode(encoder0PinB, INPUT); 
  digitalWrite(encoder0PinB, HIGH);       // turn on pullup resistor
  
  attachInterrupt(0, readEncoder, CHANGE);
  Serial.begin(57600);
}

//returs smoothed analog values
void readAnalogValues(){
    A02Value = (0.9 * A02Value) + (0.1 * analogRead(A2)) / 4;  //read analog pin 2 (2nd player)
    A03Value = (0.9 * A03Value) + (0.1 * analogRead(A3)) / 4;  //read analog pin 3 (3rd player)
    A04Value = (0.9 * A04Value) + (0.1 * analogRead(A4)) / 4;  //read analog pin 4 (4th player)
    A05Value = (0.9 * A05Value) + (0.1 * analogRead(A5)) / 4;  //read analog pin 5 (1st mic)
}


void loop() {    

    // read from the sensors
    //readAnalogValues();
/*      
    Serial.write(A02); 
    Serial.write(A02_Average); 
    
    Serial.write(A03); 
    Serial.write(A03_Average); 
    
    Serial.write(A04); 
    Serial.write(A04_Average); 

    Serial.write(A05);
    Serial.write(A05Value);
    delay(50);
*/   
 
}

/* See this expanded function to get a better understanding of the
 * meanings of the four possible (pinA, pinB) value pairs:
 */
void readEncoder(){
  bouncerA.update();
  bouncerB.update(); 
  
  if (bouncerA.read() == HIGH) {   // found a low-to-high on channel A
    if (bouncerB.read() == LOW) {  // check channel B to see which way
                                             // encoder is turning
      A01Value = A01Value - 1;         // CCW
    } 
    else {
      A01Value = A01Value + 1;         // CW
    }
  }
  else                                        // found a high-to-low on channel A
  { 
    if (bouncerB.read() == LOW) {   // check channel B to see which way
                                              // encoder is turning  
      A01Value = A01Value + 1;          // CW
    } 
    else {
      A01Value = A01Value - 1;          // CCW
    }

  }
  if(A01Value > 70) A01Value = 70;
  else if(A01Value < 0) A01Value = 0;
  int val = A01Value;
  val = val * 3.64f;
  Serial.write(A01);
  Serial.write(val);          // debug - remember to comment out
                                     // before final program run
  // you don't want serial slowing down your program if not needed
}


