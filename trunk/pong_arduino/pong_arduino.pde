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

const int NUM_READINGS = 5;

int A01Readings[NUM_READINGS];
int A02Readings[NUM_READINGS];
int A03Readings[NUM_READINGS];
int A04Readings[NUM_READINGS];

int index = 0; 
int A01_Total = 0; 
int A02_Total = 0; 
int A03_Total = 0; 
int A04_Total = 0; 

int A01_Average = 0; 
int A02_Average = 0; 
int A03_Average = 0; 
int A04_Average = 0; 

void setup() {
  Serial.begin(57600);
  for (int i = 0; i < NUM_READINGS; i++){
    A01Readings[i] = 0;
    A02Readings[i] = 0;
    A03Readings[i] = 0;
    A04Readings[i] = 0;
  }
}

void readAnalogValues(){
    A01Readings[index] = analogRead(A1) / 4;  //read analog pin 1 (1st player)
    A02Readings[index] = analogRead(A2) / 4;  //read analog pin 2 (2nd player)
    A03Readings[index] = analogRead(A3) / 4;  //read analog pin 3 (3rd player)
    A04Readings[index] = analogRead(A4) / 4;  //read analog pin 4 (4th player)
}

void loop() {    
    // subtract the last reading:
    A01_Total = A01_Total - A01Readings[index];
    A02_Total = A02_Total - A02Readings[index];
    A03_Total = A03_Total - A03Readings[index];
    A04_Total = A04_Total - A04Readings[index];
    
    // read from the sensors
    readAnalogValues();
    
    // add the reading to the total:
    A01_Total = A01_Total + A01Readings[index]; 
    A02_Total = A02_Total + A02Readings[index]; 
    A03_Total = A03_Total + A03Readings[index]; 
    A04_Total = A04_Total + A04Readings[index]; 
    
    // advance to the next position in the array:  
    index++;
    
    // if we're at the end of the array...
    if (index >= NUM_READINGS) index = 0; 
    
    // calculate the average:
    A01_Average = A01_Total / NUM_READINGS; 
    A02_Average = A02_Total / NUM_READINGS; 
    A03_Average = A03_Total / NUM_READINGS; 
    A04_Average = A04_Total / NUM_READINGS; 
    
    Serial.write(A01); 
    Serial.write(A01_Average);
   
    Serial.write(A02); 
    Serial.write(A02_Average); 
    
    Serial.write(A03); 
    Serial.write(A03_Average); 
    
    Serial.write(A04); 
    Serial.write(A04_Average); 
    
    delay(50);
}
