int analog01 = 0;    // 1st analog sensor
int analog02 = 0;    // 2nd analog sensor
int analog03 = 0;    // 3rd analog sensor
int analog04 = 0;    // 4th analog sensor

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

void setup() {
  Serial.begin(57600);
}

void loop() {
    //read analog pin 1 (1st player)
    analog01 = analogRead(A1) / 4;
    
    //read analog pin 2 (2nd player)
    analog02 = analogRead(A2) / 4;
    
    //read analog pin 3 (3rd player)
    analog03 = analogRead(A3) / 4;
    
    //read analog pin 4 (4th player)
    analog04 = analogRead(A4) / 4;
    
    Serial.write(A01); 
    Serial.write(analog01);
    
    Serial.write(A02); 
    Serial.write(analog02); 
    
    Serial.write(A03); 
    Serial.write(analog03); 
    
    Serial.write(A04); 
    Serial.write(analog04); 
  
    delay (50);
}
