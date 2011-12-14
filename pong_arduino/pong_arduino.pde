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
  pinMode(7, INPUT);
  pinMode(5, INPUT);
  pinMode(6, OUTPUT);
  digitalWrite(6, LOW);
  digitalWrite(5, HIGH);
  digitalWrite(7, HIGH);
  Serial.begin(57600);
}

//returs smoothed analog values
void readAnalogValues(){
    //A01Value = (0.9 * A01Value) + (0.1 * analogRead(A1)) / 4;  //read analog pin 1 (1st player)
    A02Value = (0.9 * A02Value) + (0.1 * analogRead(A2)) / 4;  //read analog pin 2 (2nd player)
    A03Value = (0.9 * A03Value) + (0.1 * analogRead(A3)) / 4;  //read analog pin 3 (3rd player)
    A04Value = (0.9 * A04Value) + (0.1 * analogRead(A4)) / 4;  //read analog pin 4 (4th player)
    A05Value = (0.9 * A05Value) + (0.1 * analogRead(A5)) / 4;  //read analog pin 5 (1st mic)
}

void loop() {    

    // read from the sensors
    readAnalogValues();
/*    
    Serial.write(A01); 
    Serial.write(A01_Average);
   
    Serial.write(A02); 
    Serial.write(A02_Average); 
    
    Serial.write(A03); 
    Serial.write(A03_Average); 
    
    Serial.write(A04); 
    Serial.write(A04_Average); 
 */ 
/* 
    state = (digitalRead(7) << 1) | digitalRead(5);
    if (state != prevstate) {
      if (state == nextEncoderState[prevstate]) {
        count++;
      } else if (state == prevEncoderState[prevstate]) {
        count--; 
      }
      prevstate = state;
    }
*/
    
    //Serial.write(A01);
    //Serial.write(A01Value); 
 
    Serial.write(A05);
    Serial.write(A05Value);
    delay(50);
}


