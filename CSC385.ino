int incomingByte = 0;
int ck = 3;
int trans = 2;
int interval = 1000;

void wByte(int b) {

  digitalWrite(trans, LOW);

  delay(interval);

  digitalWrite(ck, HIGH);

  delay(interval);

  digitalWrite(ck, LOW);

  if (b & 1) {
    digitalWrite(trans, HIGH);
  } else {
    digitalWrite(trans, LOW);
  }
   delay(interval);

  digitalWrite(ck, HIGH);

  delay(interval);

  digitalWrite(ck, LOW);

  if (b & 2) {
    digitalWrite(trans,HIGH);
  }else {
    digitalWrite(trans, LOW);
  }

  delay(interval);

  digitalWrite(ck, HIGH);

  delay(interval);
  digitalWrite(ck, LOW);

  if (b & 4) {
    digitalWrite(trans, HIGH);
  }else {
    digitalWrite(trans, LOW);
  }

  delay(interval);

  digitalWrite(ck, HIGH);

  delay(interval);
  digitalWrite(ck, LOW);

  delay(interval);

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
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    digitalWrite(13, HIGH);
    wByte(incomingByte);    
  }
  wByte(0);

}
