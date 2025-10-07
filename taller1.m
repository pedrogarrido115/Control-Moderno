clc;
tabla = readtable("data_motor.csv");

%Ziegler-Nichols

K1 = 2/3;
theta1 = 0.151515;
tau1 = 0.959595;


G1 = tf(K1, [tau1 1], "InputDelay", theta1);
y1 = lsim(G1, tabla.ex_signal_u_, tabla.time_t_);

%Miller

K2 = K1;
theta2 = theta1;
tau2 = 0.631313;

G2 = tf(K2, [tau2 1], "InputDelay", theta2);
y2 = lsim(G2, tabla.ex_signal_u_, tabla.time_t_);

%Analítico

K3 = K2;
theta3 = 0.21806;
tau3 = 0.55794;

G3 = tf(K3, [tau3 1], "InputDelay", theta3);
y3 = lsim(G3, tabla.ex_signal_u_, tabla.time_t_);

mse1 = mean((y1 - tabla.system_response_y_).^2);
mse2 = mean((y2 - tabla.system_response_y_).^2);
mse3 = mean((y3 - tabla.system_response_y_).^2);


figure
hold on;
plot(tabla.time_t_, tabla.ex_signal_u_)
plot(tabla.time_t_, ones([1 length(tabla.time_t_)]))
plot(tabla.time_t_,tabla.system_response_y_)
plot(tabla.time_t_, y1)
plot(tabla.time_t_, y2)
plot(tabla.time_t_, y3)

legend("Escalón", "Línea 100% Aprox", "Respuesta del motor real", "Ziegler & Nichols", "Miller", "Analítico")

xlabel("Tiempo (s)")
ylabel("Velocidad del motor (KRPM)")

grid on;

fprintf('MSE Ziegler & Nichols = %.5f\n', mse1);
fprintf('MSE Miller = %.5f\n', mse2);
fprintf('MSE Analítico = %.5f\n', mse3);
