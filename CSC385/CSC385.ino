int incomingByte = 0;
int clock = 3;
int trans = 2;
int interval = 300;
int timeInterval = 1000;

void wByte(int b) {
  for(int i=3; i>=0; i--) {
    digitalWrite(trans, ((b >> i) & 1) ? HIGH : LOW);
    // Serial.print((b >> i) & 1);
    delay(interval);
    digitalWrite(clock, HIGH);
    delay(interval);
    digitalWrite(clock, LOW);
    digitalWrite(trans, LOW);
    delay(interval);
  }
}


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(13, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(13, LOW);
  char bytes[3];
  int nbyte = 2;

  while (nbyte >= 0) {
    while (Serial.available() > 0) {
      bytes[nbyte] = Serial.read() - '0';
      nbyte--;  
    }
    wByte(0);
  }
 
  Serial.write("processing input block...\n");
  digitalWrite(13, HIGH);
  while (
    bytes[0] > 0 ||
    bytes[1] > 0 ||
    bytes[2] > 0) {
  
      byte filter = 
        ((bytes[0]) ? 0b001 : 0b000) |
        ((bytes[1]) ? 0b010 : 0b000) |
        ((bytes[2]) ? 0b100 : 0b000);
  
      Serial.print(filter);
      Serial.write(": ");
      wByte(filter);
      Serial.write("\n");
      digitalWrite(13, LOW);
      
      bytes[0] = ((bytes[0] > 0) ? bytes[0] - 1 : 0);
      bytes[1] = ((bytes[1] > 0) ? bytes[1] - 1 : 0);
      bytes[2] = ((bytes[2] > 0) ? bytes[2] - 1 : 0);
      delay(timeInterval);
   }
  Serial.write("resetting to 'off'\n");
  wByte(0);
  Serial.write("done processing input block\n");
  nbyte = 0;
}
