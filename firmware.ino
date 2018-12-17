int pushButton = D3;
int outletPin = D1;
bool sleepMode = false;
bool screenOn = true;
bool bedOccupied = false;

// Appliance Control Functions
int turnOnAll(String args) {
    digitalWrite(outletPin,HIGH);
}

int turnOffAll(String args) {
    digitalWrite(outletPin, LOW);
}

// Sleep Mode Functions

int activateSleepMode(String args) {
    sleepMode = true;
}

int deactivateSleepMode(String args) {
    sleepMode = false;
}

// Mobile Phone Screen Functions

int setScreenClosed(String args) {
    screenOn = false;
}

int setScreenOpen(String args) {
    screenOn = true;
}

int isBedOccupied(String args) {
    if (digitalRead(pushButton) == LOW){
        bedOccupied = true;
    }else{
        bedOccupied = false;
    }
}

// Setup Photon
void setup() {
    pinMode(pushButton, INPUT_PULLUP);
    pinMode(outletPin, OUTPUT);
    
    
    // Initial setup with blinking LED
    digitalWrite(outletPin, HIGH);
    digitalWrite(D7, HIGH);
    digitalWrite(D7, LOW);
    digitalWrite(D7, HIGH);
    digitalWrite(D7, LOW);
    
    
    // Cloud Function Setup
    Particle.function("turnOnAll", turnOnAll);
    Particle.function("turnOffAll", turnOffAll);
    Particle.function("sleepModeOn", activateSleepMode);
    Particle.function("sleepModeOff", deactivateSleepMode);
    Particle.function("screenOff", setScreenClosed);
    Particle.function("screenOn", setScreenOpen);
}

void loop() {
    if (sleepMode == true){
        isBedOccupied("Test");

        if (screenOn == false){
            if (bedOccupied == true){
                digitalWrite(outletPin, LOW);
            }else{
                digitalWrite(outletPin, HIGH);
            }
        }else{
            digitalWrite(outletPin, HIGH);
        }
    }
}

