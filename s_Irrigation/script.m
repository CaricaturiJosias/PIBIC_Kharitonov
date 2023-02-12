clc;
clear;
close all;
syms K;

addpath("..");

t_max = 1500;
timestep = t_max/1e6;
step_v = 0.4;

syms s;

% tal -> [300, 900]
% K -> [1.25, 3.125]
% T1 -> [6, 6000]
% L -> [2, 3]

e = round(exp(1), 5, 'significant');
tal = 600;
K1 = 1.25;
K2 = 3.125;
T11 = 60;
T12 = 80;
T21 = 50;
T22 = 100;

% yDown = K1/((T11*s+1)*(T12*s+1));
yDown = K1/(T11*T12*s^2 + (T11 + T12)*s + 2);
% yUp = K2/((T21*s+1)*(T22*s+1));
yUp = K2/(T21*T22*s^2 + (T21 + T22)*s + 2);

[numD, denD] = numden(yDown);
numD = sym2poly(numD);
denD = sym2poly(denD);

[numU, denU] = numden(yUp);
numU = sym2poly(numU);
denU = sym2poly(denU);

transferD = tf(numD,denD, 'InputDelay', tal);
transferU = tf(numU,denU, 'InputDelay', tal);

transferU = pade(transferU, 1);
transferD = pade(transferD, 1);
transferU
 
% [numU, denU] = tfdata(transferU);
% [numD, denD] = tfdata(transferD);
% numU = poly2sym(cell2mat(numU), s);
% denU = poly2sym(cell2mat(denU), s);
% numD = poly2sym(cell2mat(numD), s);
% denD = poly2sym(cell2mat(denD), s);
% 
% transferU = numU/denU;
% transferD = numD/denD;
% 
% transferU = ilaplace(transferU);
% transferD = ilaplace(transferD);
% 
% Cd = 5;
% L = 2.5; 
% g = 9.81;
% 
% q_t = simplify(q_t);
% func = laplace(q_t);
% [NUM, DEN] = numden(func);
% NUM = sym2poly(NUM);
% DEN = sym2poly(DEN);
% 
% func = tf(NUM,DEN);

% t = 0:timestep:t_max;
% res_q_t= subs(q_t,t);
% 
% figure(1);
% plot(t, res_q_t);
% 
% figure(2);
% step(transferD);
% hold on;
% step(transferU);
% 
% res = sim("simu.slx");