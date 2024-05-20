float analogPins[] = {0, 1, 2, 3, 4, 5};

void setup() 
{ 
  Serial.begin(9600);
} 

void loop() 
{ 
  for (int pin = 0; pin < 6; pin++)
  {
    int value = analogRead(analogPins[pin]);
    Serial.print(value);
    Serial.print(" ");
  }
  Serial.println();
}
