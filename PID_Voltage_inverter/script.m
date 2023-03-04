clc;
clear;
close all;

t_max = 0.1;
timestep = t_max/1e7;

step_v = 1;

t_v = timestep:timestep:t_max;

Rg = 0.2;
Lg = 150e-6; % 1-100 uH
Cf = 50e-6;
Lf = 1e-3;
F = 1/0.02; % Hz

K = (Lf*Rg)/Lg;

transferOne = tf(1, [Lf 0]);
transferTwo = tf(1, [Lg*Cf Cf*Rg 1]);

transfer = transferOne*transferTwo;

res = sim("tension_inverter_2016.slx");
t = res.tout;

subtitle = "Corrente de saída [A]";

PID_Run(transfer, "MF", t, K, subtitle, 0)