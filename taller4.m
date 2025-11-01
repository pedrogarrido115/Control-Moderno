clear;
clc;
%Valores circuito RLC
R = 10; 
L = 0.1; 
Cap = 220e-6;
%Matrices
A = [-R/L -1/L; 1/Cap 0];
B = [1/L; 0];
C = [0 1];
D = 0;

sys = ss(A,B,C,D); %Espacio de estados

figure(1);

subplot(2,1,1);
step(sys);
xlabel('Time [s]'); ylabel('Vc [V]');
grid on;

subplot(2,1,2);
impulse(sys);
xlabel('Time [s]'); ylabel('Vc [V]')
grid on;

[num, den] = ss2tf(A,B,C,D); %Función de transferencia

[Ax, Bx, Cx, Dx] = tf2ss(num,den); %Regreso a espacio de estados (variables distintas)

function dx = modelRLC(x, A, B, u)
 dx = A * x + B * u; % Ecuación de Estado
end

ts = 0.2; %Tiempo de visualización

tspan = [0 ts]; %Vector de resolución de tiempo
u = 1; %Entrada
x0 = [0; 0]; %Coniciones iniciales

[t, X] = ode45(@(t,x) modelRLC(x, A, B, u), tspan, x0); %Función integradora
y = C * X.' + D * u;

figure(2);

plot(t,y)

grid on;

s3 = readtable("s3.csv"); % Archivo con los valores de la entrada formada por escalones 

u2 = s3.Se_al; %Entrada de dos escalones
x02 = zeros(length(u2),2); %Condiciones iniciales
tspan2 = s3.Tiempo_s;

for k = 2 : length(u2) %Dimensión del vector u2

 [tk, Xk] = ode45(@(t,x) modelRLC(x, A, B, u2(k-1)),[tspan2(k-1), tspan2(k)], x02(k-1,:));

 t2(k) = tk(end,:);
 x02(k,:) = Xk(end,:);
 
end

y2 = C * x02.';

figure(3);

plot(t2,y2)

grid on;

