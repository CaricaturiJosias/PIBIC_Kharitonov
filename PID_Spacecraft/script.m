close all;
clear;
clc;

step_v = 1;
Jx = 1150;
Jy = 1490;
Jz = 890;

Ka = 2;  % [2, 2.2]
Ta = 0.5; % [0.5, 0.6]

t_max = 1e3;
timestep = t_max/1e6;
profile = [0 1; t_max 1];

J = Jx;

res = sim("spacecraft.slx");

figure(1);
plot(res.tout, res.out);

entrada = 180/pi;
K = entrada;

num = entrada;
den = [J 0 0];
transfer = tf(num,den);

transfer = feedback(transfer,(1/entrada));

res = sim("spacecraft.slx");
t = res.tout;
figure(1);
plot(res.tout, res.out);

figure(2);
[stepOut, stepT] = step(transfer);
plot(stepT, stepOut*(1/entrada));

type = "MF";
subtitle = "Ângulo [º]";
PID_Run(transfer, type, t, K, subtitle, 0);
