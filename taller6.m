clear; clc;

%Primer orden

Gs1 = tf(1,[2 1]); Gs2 = tf(1,[2 -1]);

figure(1); grid on;

subplot(1,2,1); step(Gs1)

subplot(1,2,2); step(Gs2)

%Segundo orden

Gs3 = tf(1,[1 2*0*1 1]);
Gs4 = tf(1,[1 2*0.5*1 1]);
Gs5 = tf(1,[1 2*1*1 1]);
Gs6 = tf(1,[1 2*2*1 1]);
Gs7 = tf(1,[1 -0.5 4]);
Gs8 = tf(1,[25 -12.5 1]);

figure(2); 

subplot(2,2,1); step(Gs3); xlim([0 30]); grid on;
subplot(2,2,3); pzmap(Gs3);
subplot(2,2,2); step(Gs4); xlim([0 30]); grid on;
subplot(2,2,4); pzmap(Gs4);

figure(3);

subplot(2,2,1); step(Gs5); xlim([0 30]); grid on;
subplot(2,2,3); pzmap(Gs5);
subplot(2,2,2); step(Gs6); xlim([0 30]); grid on;
subplot(2,2,4); pzmap(Gs6);

figure(4);

subplot(2,2,1); step(Gs7); xlim([0 30]); grid on;
subplot(2,2,3); pzmap(Gs7);
subplot(2,2,2); step(Gs8); xlim([0 30]); grid on;
subplot(2,2,4); pzmap(Gs8);

%Ejercicio 1

G1 = tf(3,[1 0]);
G2 = tf(1,[1 0 1]);
H = tf(3,1);
feedback(series(G1,G2),H);

figure(5); 

step(feedback(series(G1,G2),H)); xlim([0 10]); ylim([-3000 1000]); grid on;

%Ejercicio 2

%Circuito RLC
R = 10; L = 0.1; C = 220e-6;
GRLC = tf(1/(L*C), [1 R/L 1/(L*C)]);

%Controlador PID

Kp = 89.0609480606665;
Ki = 18678.6278431285;
Kd = 0.10521281880029;

GPID = tf([Kd Kp Ki],[1 0]);

%Función lazo cerrado
Gx = feedback(series(GRLC,GPID),1);

pole(Gx) %Polos

figure(6);

subplot(1,2,1);pzmap(Gx);%Diagrama polos/ceros

subplot(1,2,2);step(Gx);%Respuesta en el tiempo (Mp = 10%)

