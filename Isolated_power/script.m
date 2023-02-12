close all;
clear;
clc;

step_v = 100;
random_power = step_v/1e6;
t_max = 1;
timestep = t_max/1e6;

Kae = 1;
Kdg = 1;
Kf = 1;
Kwt = 1;

Tae = 0.2;
Tdg = 2;
Tf = 4;
Twt = 1.5;

Kp = 2;
Tp = 20;
Kg = 1;
Ku = 0.4;
Td = 0.024;
