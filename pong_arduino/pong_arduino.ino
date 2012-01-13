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
byte Rotary_01 = B001;
byte Rotary_02 = B011;
byte Slider_01 = B010;
byte Slider_02 = B000;

//mic identification bytes
byte Mic_01 = B110;
byte Mic_02 = B111;
byte Mic_03 = B101;
byte Mic_04 = B100;

int Rotary_01_Value = 0;
int Rotary_02_Value = 0;
int Slider_01_Value;
int Slider_02_Value;
int Mic_01_Value;
int Mic_02_Value;
int Mic_03_Value;
int Mic_04_Value;

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
    Slider_01_Value = (0.8 * Slider_01_Value) + (0.2 * analogRead(1)) / 4;  //read analog pin 3 (3rd player)
    Slider_02_Value = (0.8 * Slider_02_Value) + (0.2 * analogRead(2)) / 4;  //read analog pin 4 (4th player)
    Mic_01_Value = (0.9 * Mic_01_Value) + (0.1 * analogRead(4)) / 4;  //read analog pin 5 (1st mic)
    Mic_02_Value = (0.9 * Mic_02_Value) + (0.1 * analogRead(4)) / 4;  //read analog pin 5 (2nd mic)
    Mic_03_Value = (0.9 * Mic_03_Value) + (0.1 * analogRead(5)) / 4;  //read analog pin 5 (3rd mic)
    Mic_04_Value = (0.9 * Mic_04_Value) + (0.1 * analogRead(6)) / 4;  //read analog pin 5 (4th mic)
}


void loop() {   
  
    //delay with millis
    unsigned long currentMillis = millis();
    if(currentMillis - previousMillis > 50){
      previousMillis = currentMillis;

      // read from the sensors
      readAnalogValues();    
             
      Serial.write(Slider_01);
      Serial.write(Slider_01_Value);
     
      Serial.write(Slider_02);
      Serial.write(Slider_02_Value);
      
      Serial.write(Mic_01);
      Serial.write(Mic_01_Value);
      
      Serial.write(Mic_02);
      Serial.write(Mic_02_Value);
      
      Serial.write(Mic_03);
      Serial.write(Mic_03_Value);
      
      Serial.write(Mic_04);
      Serial.write(Mic_04_Value);
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
      Rotary_01_Value = Rotary_01_Value - 1;
    }
    else {
      //encoder turns CW
      Rotary_01_Value = Rotary_01_Value + 1;
    }
  }
  else {                            // found a high-to-low on channel A
    if (bouncerB.read() == LOW) {   // check channel B to see which way
      //encoder turns CW 
      Rotary_01_Value = Rotary_01_Value + 1;
    } 
    else {
      //encoder turns CCW 
      Rotary_01_Value = Rotary_01_Value - 1;
    }

  }
  
  //check min & max thresholds
  if(Rotary_01_Value > 70) Rotary_01_Value = MAX_VALUE;
  else if(Rotary_01_Value < 0) Rotary_01_Value = MIN_VALUE;
   
  Serial.write(Rotary_01);
  Serial.write(Rotary_01_Value); 
}

void readEncoderB(){
  bouncerC.update();
  bouncerD.update(); 
  
  if (bouncerC.read() == HIGH) {   // found a low-to-high on channel A
    if (bouncerD.read() == LOW) {  // check channel B to see which way
      //encoder turns CCW 
      Rotary_02_Value = Rotary_02_Value - 1;
    }
    else {
      //encoder turns CW
      Rotary_02_Value = Rotary_02_Value + 1;
    }
  }
  else {                            // found a high-to-low on channel A
    if (bouncerD.read() == LOW) {   // check channel B to see which way
      //encoder turns CW 
      Rotary_02_Value = Rotary_02_Value + 1;
    } 
    else {
      //encoder turns CCW 
      Rotary_02_Value = Rotary_02_Value - 1;
    }

  }
  
  //check min & max thresholds
  if(Rotary_02_Value > 70) Rotary_02_Value = MAX_VALUE;
  else if(Rotary_02_Value < 0) Rotary_02_Value = MIN_VALUE;
   
  Serial.write(Rotary_02);
  Serial.write(Rotary_02_Value);  
}
