clear;
close all;
clc;

t_max = 0.1;
timestep = t_max/10000;
step_v = 1000;
time = 0:timestep:t_max;

R = 21.2;
Kb = 0.1433;
D = 1e-4;
L = 0.052;
Kt = 0.1433;
J = 1e-5;

num = Kt*Kb/(L*J);
den = [1 ((L*D+R*J)/(L*J)) Kt*Kb/(L*J)];
sim("bldc_2016_mamf.slx");

transfer = tf(num, den);
[num, den] = tfdata(transfer, 'v');

type = "MA";
subtitle = "Velocidade angular (rad/s)";
MF_K = 0;
t = tout;
PID_Run(transfer, type, t, MF_K, subtitle, 0);
