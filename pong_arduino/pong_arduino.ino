#include <Bounce.h>

#define encoder0PinA  2
#define encoder0PinB  4

#define encoder0PinC  3
#define encoder0PinD  5

Bounce bouncerA = Bounce(encoder0PinA, 5);
Bounce bouncerB = Bounce(encoder0PinB, 5);

Bounce bouncerC = Bounce(encoder0PinC, 5);
Bounce bouncerD = Bounce(encoder0PinD, 5);

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
int A03Value = 0;
int A04Value;
int A05Value;
int A06Value;
int A07Value;
int A08Value;

boolean A_set;
boolean B_set;

//encoder variables
int state, prevstate = 0, count = 0;
int stateB, prevstateB = 0, countB = 0;
int nextEncoderState[4] = { 2, 0, 3, 1 };
int prevEncoderState[4] = { 1, 3, 0, 2 };

static int MAX_VALUE = 70;
static int MIN_VALUE = 0;

// will store last time analog values has been sent
long previousMillis = 0;

void setup() {
  pinMode(encoder0PinA, INPUT); 
  digitalWrite(encoder0PinA, HIGH);       // turn on pullup resistor
  pinMode(encoder0PinB, INPUT); 
  digitalWrite(encoder0PinB, HIGH);       // turn on pullup resistor
 
  pinMode(encoder0PinC, INPUT); 
  digitalWrite(encoder0PinC, HIGH);       // turn on pullup resistor
  pinMode(encoder0PinD, INPUT); 
  digitalWrite(encoder0PinD, HIGH);       // turn on pullup resistor

  
  attachInterrupt(0, readEncoder, CHANGE);
  attachInterrupt(1, readEncoderB, CHANGE);
  Serial.begin(57600);
}

//returs smoothed analog values
void readAnalogValues(){
    //A01Value = (0.9 * A01Value) + (0.1 * analogRead(1)) / 4;  //read analog pin 2 (1st player)
    A02Value = (0.9 * A02Value) + (0.1 * analogRead(2)) / 4;  //read analog pin 3 (3rd player)
    A04Value = (0.9 * A04Value) + (0.1 * analogRead(4)) / 4;  //read analog pin 4 (4th player)
    A05Value = (0.9 * A05Value) + (0.1 * analogRead(5)) / 4;  //read analog pin 5 (1st mic)
    A06Value = (0.9 * A06Value) + (0.1 * analogRead(6)) / 4;  //read analog pin 5 (2nd mic)
    A07Value = (0.9 * A07Value) + (0.1 * analogRead(7)) / 4;  //read analog pin 5 (3rd mic)
    A08Value = (0.9 * A08Value) + (0.1 * analogRead(8)) / 4;  //read analog pin 5 (4th mic)
}


void loop() {   
  
    //delay with millis
    unsigned long currentMillis = millis();
    if(currentMillis - previousMillis > 50){
      previousMillis = currentMillis;

      // read from the sensors
      readAnalogValues();    
                 
      Serial.write(A02);
      Serial.write(A02Value);
      
      Serial.write(A04);
      Serial.write(A04Value);
      
      Serial.write(A05);
      Serial.write(A05Value);
      
      Serial.write(A06);
      Serial.write(A06Value);
      
      Serial.write(A07);
      Serial.write(A07Value);
      
      Serial.write(A08);
      Serial.write(A08Value);
    } 
}

/* See this expanded function to get a better understanding of the
 * meanings of the four possible (pinA, pinB) value pairs:
 */
void readEncoder(){
  bouncerA.update();
  bouncerB.update(); 
  
  if (bouncerA.read() == HIGH) {   // found a low-to-high on channel A
    if (bouncerB.read() == LOW) {  // check channel B to see which way
      //encoder turns CCW 
      A03Value = A03Value - 1;
    }
    else {
      //encoder turns CW
      A03Value = A03Value + 1;
    }
  }
  else {                            // found a high-to-low on channel A
    if (bouncerB.read() == LOW) {   // check channel B to see which way
      //encoder turns CW 
      A03Value = A03Value + 1;
    } 
    else {
      //encoder turns CCW 
      A03Value = A03Value - 1;
    }

  }
  
  //check min & max thresholds
  if(A03Value > 70) A03Value = MAX_VALUE;
  else if(A03Value < 0) A03Value = MIN_VALUE;
   
  Serial.write(A03);
  Serial.write(A03Value); 
}

void readEncoderB(){
  bouncerC.update();
  bouncerD.update(); 
  
  if (bouncerC.read() == HIGH) {   // found a low-to-high on channel A
    if (bouncerD.read() == LOW) {  // check channel B to see which way
      //encoder turns CCW 
      A01Value = A01Value - 1;
    }
    else {
      //encoder turns CW
      A01Value = A01Value + 1;
    }
  }
  else {                            // found a high-to-low on channel A
    if (bouncerD.read() == LOW) {   // check channel B to see which way
      //encoder turns CW 
      A01Value = A01Value + 1;
    } 
    else {
      //encoder turns CCW 
      A01Value = A01Value - 1;
    }

  }
  
  //check min & max thresholds
  if(A01Value > 70) A01Value = MAX_VALUE;
  else if(A01Value < 0) A01Value = MIN_VALUE;
   
  Serial.write(A01);
  Serial.write(A01Value);  
}
