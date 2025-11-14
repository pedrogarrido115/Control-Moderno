%Circuito RLC
R = 5;
L = 0.1;
Cap = 220e-6;

%Función de transferencia G(s)
num = 1/(L*Cap);
den = [1 R/L 1/(L*Cap)];

%Ganancia controlador P
K = 100;

%Ganancias contorlador PID
Kp = 89.0609480606665;
Ki = 18678.6278431285;
Kd = 0.10521281880029;
N = 552624.357051415;