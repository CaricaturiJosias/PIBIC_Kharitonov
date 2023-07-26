clc;
clear;
close all;
syms K;

addpath("..");

t_max = 1500;
timestep = 100e-3; % 100 ms
step_v = 0.4;

syms s;

% tal -> [300, 900]
% K -> [1.25, 3.125]
% T1 -> [6, 6000]
% L -> [2, 3]

tal = 600;
K1 = 1.5;
T11 = 10;
T12 = 1;

% yDown = K1/((T11*s+1)*(T12*s+1));
yDown = pade(tf(K1, [T11*T12 (T11 + T12) 2], 'InputDelay', tal),1);
[numD, denD] = tfdata(yDown, 'v');

upstreamHeight = 0.4; % 0.4 m

% Set the disturbance constants
Cd = 5;
L = 8e-2; % 8 cm 
g = 9.81;

res = sim("simu.slx");

figure();
plot(res.tout/60, res.down); grid on;
ylabel("Water level [m]");
xlabel("Time [s]");
title("Downstream gate water level [m]");

figure();
plot(res.tout/60, res.up); grid on;
ylabel("Water level [m]");
xlabel("Time [s]");
title("Upstream gate water level [m]");

figure();
plot(res.tout, res.disturbance); grid on;
ylabel("Dischard [m^3 s^-1]");
xlabel("Time [s]");
title("Discharge disturbance");