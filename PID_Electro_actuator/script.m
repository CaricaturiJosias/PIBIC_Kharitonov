close all;
clear;
clc;

syms s k;

t_max = 40;
timestep = t_max/1e6;
step_v = 1;

Ra = 7.5;
La = 0.067;
Ce = 0.129;
Ca = 4.125;
Ja = 0.06;
Bt = 0.03;

a1 = -(Ra/La) - (Bt/Ja);
a2 = -(Ra*Bt+Ce*Ca)/(La*Ja);

b = -Ca/(La*Ja);

fd = 0; % Não consideraremos distúrbio agora

fwu = -a2*step_v; % Constante, então wu*d^2/dt^2 nem wu*d/dt são 0

d = 0; % a1, a2 e b não são variáveis nessa simulação

% K = (a1*a2*(La+Ra))/(b*(La*Ja));

A = [ 0 1  0;
      0 0  1;
      0 a2 a1];

B = [0; 0; fwu];

% Dimensões das matrizes
n = size(A, 1);
p = size(B, 2);
q = 1;

C = ones(q,n);
D = zeros(q,p);

[NUM,DEN] = ss2tf(A,B,C,D);

transfer = tf(NUM,DEN);
K = routh(transfer);
K = sym2poly(K(1));
transfer = feedback(transfer*K, 1);

% Aplicação

res = sim("actuator.slx");

t = res.tout;
type = "MA";
subtitle = "Velocidade angular (rad/seg)";
f_0 = 2.5;
PID_Run(transfer, type, t, 0, subtitle, f_0);
