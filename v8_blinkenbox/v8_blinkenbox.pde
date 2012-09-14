/*
  Blinkenbox
  "Booster Panel" for "V8"
  Karsten W. Rohrbach, 2012
  <karsten@rohrbach.de> @byteborg
 */

// pins for switches (input)
// analog A0 and A1 in digital mode

// pins for pot (analog input)
// analog A2

// pins for lamps (output):
// yellow: 4 5 6 green: 7 
// yellow: 8 9 10 green: 11

const int SW0 = A0;
const int SW1 = A1;
const int POT = A2;
const int SAMPLES = 8; // POT smoothing
const int SPDFACTOR = 23; // scaling factor for POT (0..1023)
const int L0[] = { 4, 5, 6, 7 };
const int L1[] = { 8, 9, 10, 11 };
const int LAMPS = 4; // no. of lamps

const int STOP = 0;
const int UP = 1;
const int DOWN = 2;

int i = 0;
int t = 0;
int spd = 400; // initial system timing in ms

void readSpeedPot() {
    // init speed from pot
  for (i=0; i < SAMPLES; i++) {
    t =+ analogRead(POT);  
    delay(5);
  }
  spd = t / SAMPLES * SPDFACTOR;
}

void setup() {
  // init pins for switches
  pinMode(SW0, INPUT);
  pinMode(SW1, INPUT);
  // init pins for lamps
  for(i=0; i<LAMPS; i++) {
    pinMode(L0[i], OUTPUT);     
    pinMode(L1[i], OUTPUT);
    digitalWrite(L0[i], LOW);
    digitalWrite(L1[i], LOW);
  }
  readSpeedPot();
}

int state0 = STOP;
int state1 = STOP;
int pos0 = 0;
int pos1 = 0;



void loop() {
  // read switches
  t = digitalRead(SW0);
  if (t == LOW) {
    state0 = UP;
  } else {
    state0 = DOWN;
  }
  t = digitalRead(SW1);
  if (t == LOW) {
    state1 = UP;
  } else {
    state1 = DOWN;
  }
  // read speed pot
  readSpeedPot();
  // timing, yeah
  delay(spd);
  // react on state
  if (state0 == UP) {
    // count up
    if (pos0 < LAMPS) {
      pos0++;
      for (i=0; i < LAMPS; i++)
        digitalWrite(L0[i], (i < pos0));
    }
  } else if (state0 == DOWN) {
    // count down
    if (pos0 > 0) {
      pos0--;
      for (i=0; i < LAMPS; i++)
        digitalWrite(L0[i], (i < pos0));
    }
  }    
  if (state1 == UP) {
    // count up
    if (pos1 < LAMPS) {
      pos1++;
      for (i=0; i < LAMPS; i++)
        digitalWrite(L1[i], (i < pos1));
    }
  } else if (state1 == DOWN) {
    // count down
    if (pos1 > 0) {
      pos1--;
      for (i=0; i < LAMPS; i++)
        digitalWrite(L1[i], (i < pos1));
    }
  }    
}
