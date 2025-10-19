clc; clear;

num = 3; % Numerador
den = [1 2 3]; % Denominador

Gs1 = tf(num, den, "InputDelay", 2); % Función de transferencia G(s) con delay = 2

[y1, t1] = impulse(Gs1); % Impulso como entrada
[y2, t2] = step(Gs1); % Escalón como entrada

[ymax1, idt1_max] = max(y1); % Valor máximo de la respuesta a un impulso
tmax1 = t1(idt1_max); % Índice de tiempo del valor máximo de la respuesta a un impulso
[ymax2, idt2_max] = max(y2); % Valor máximo de la respuesta a un escalón
tmax2 = t2(idt2_max); % Índice de tiempo del valor máximo de la respuesta a un escalón

% Primera figura
figure(1);

plot(t1,y1,t2,y2,tmax1,ymax1, 'x', tmax2,ymax2, 'x', 'MarkerSize', 10, 'LineWidth', 2) 
xlabel("Tiempo (s)")
xlim([0 10])

grid on;

s1 = readtable("s1.csv"); % Archivo con los valores de la entrada formada por escalones 

% Segunda figura
figure(2);

subplot(1,2,1); % Entrada escalones

plot(s1.Tiempo, s1.Se_al, 'LineStyle','--','LineWidth',2)
xlabel("Tiempo (s)")
ylim([0 12])

grid on;

subplot(1,2,2); % Respuesta a los escalones

lsim(Gs1,s1.Se_al,s1.Tiempo);

grid on;

s2 = readtable("s2.csv"); % Archivo con los valores de la señal arbitraria

% Tercer figura
figure(3);

subplot(1,2,1); % Entrada señal arbitraria

plot(s2.Tiempo, s2.Se_al, 'LineStyle','--','LineWidth',2)
xlabel("Tiempo (s)")
ylim([0 30])

grid on;

subplot(1,2,2); % Respuesta a la señal arbitraria

lsim(Gs1,s2.Se_al,s2.Tiempo);

grid on;

% Actividad reto

Gs2 = tf(num, den); % Función de transferencia G(s) con delay = 0

tx = 0:0.01:40; % Vector de tiempo para la señal aleatoria

%Amplitudes aleatoria para todos los segmentos

a = 4*rand; 
b = 5*rand;
c = 5*rand;
d = 2*rand;

% Se plantean 4 segmentos: Recta creciente, escalón ascendente, escalón
% decreciente y recta decreciente

% Cada segmento dura 10 segundos

% Recta creciente: la suma de dos rectas de misma pendiente, pero con un desfase, se traduce en una señal constante
% Esta señal constante se ubica en la marca de los 10 segundos como fin del
% segmento

rx1 = a*(tx) .* (tx >= 0); % Primer componente de recta 

rx2 = -a*(tx-10) .* (tx >= 10); % Segundo componente de recta

ux1 = b*heaviside(tx - 10); % Escalón creciente

ux2 = -c*heaviside(tx - 20); % Escalón decreciente

rx3 = -d*(tx-30) .* (tx >= 30); % Escalón decreciente

sx = rx1 + rx2 + ux1 + ux2 + rx3; % La suma de todos los componentes da como resultado la señal aleatoria

%Bucle antinegativo (considera el valor de 0 para cualquier valor negativo
%de existir

for i = 1:1:4001
    
    if sx(i) < 0

        sx(i) = 0;

    end

end

% Cuarta figura
figure(4);

subplot(1,2,1); % Entrada aleatoria

plot(tx,sx)
title("Señal aleatoria")
xlabel("Tiempo (s)")

grid on;

subplot(1,2,2); % Respuesta a la señal aleatoria

lsim(Gs2,sx,tx);

grid on;