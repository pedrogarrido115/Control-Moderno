#include <Controllino.h>

#define PWM_OUT CONTROLLINO_D0
#define PULSE_IN CONTROLLINO_IN1

int pulse_counter = 0;
double rpm = 0;
long now = 0;
long ts = 50000;  // 50ms, 0.05 segundos
long tprev = 0;
int AD_POT;
double ref = 3000;
double Kp = 0.12 / 1.7; //0.07 ganancia última, Tu = ~500ms
double Ti = 350000 / 2;
double Td = 280000 / 8;
double u = 0;
static double e[3];

void pulses(){
  pulse_counter++;
}

void setup() {
  // put your setup code here, to run once:
  pinMode(PULSE_IN, INPUT_PULLUP);
  pinMode(PWM_OUT, OUTPUT);

  attachInterrupt(digitalPinToInterrupt(CONTROLLINO_IN1), pulses, FALLING);

  Serial.begin(115200);
}

double get_pulses(){
  int pul = pulse_counter;
  pulse_counter = 0;
  return pul / 0.05 / 36.0 * 60.0;
}


void loop() {
  // put your main code here, to run repeatedly:
  now = micros();
  
  if ((now - tprev) >= ts){
    
    rpm = get_pulses();

    AD_POT = analogRead(A0);
    Kp = (double) AD_POT * 0.2 / 164;

    e[0] = ref - rpm;

    //u = u + Kp * e[0];
    u = u + Kp * ( e[0] - e[1] + (ts/Ti)*e[0] + (Td/ts)*(e[0]-2*e[1]+e[2]) );
    u = constrain(u, 0, 255);

    Serial.print(u);
    Serial.print(',');
    Serial.print(Kp);
    Serial.print(',');
    Serial.println(rpm);

    analogWrite(PWM_OUT, u);

    e[2] = e[1];
    e[1] = e[0];
    tprev = now;
    
  }

}
