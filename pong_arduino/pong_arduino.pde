int firstSensor = 0;    // first analog sensor
void setup()
{

  Serial.begin(57600);
}
void loop()
{
    firstSensor = analogRead(1);
    delay(10);
    Serial.write(firstSensor); 
    Serial.write(0, BYTE);         
  
  delay (50);
}
