% Script to test and analyze the control system from 
% ----------------------------------------
% Position Control of DC Motor Using
% Genetic Algorithm Based PID Controller 
% ISBN:978-988-18210-1-0 
% ----------------------------------------
% Script information
% Made in: 16/10/2022
% Author: Gabriel Cezário
% Advisor: Ricardo Massao
% Institution: Pontifical Catholic University of Paraná
close all;
clear;
clc;

syms k;

t_max = 2;
timestep = t_max/1e6;
step_v = 1;

Kb = 1.2;
J = 0.022;
B = 5e-4;
La = 0.035;
Ra = 2.45;

num = Kb;
den = [J*La (Ra*J+B*La) (Ra*B+Kb^2) 0];
A = (J*B*Ra^2 + Ra*J*Kb^2 + Ra*La*B^2 + La*B*Kb^2 - J*La*k*Kb)/(Ra*J+B*La);
assume(k>0);
K = double(solve(A,k));

res = sim("DC_2016.slx");
transfer = tf(num,den);
type = "MF";
t = res.tout;

subtitle = "Velocidade do eixo (rad/s)";
PID_Run(transfer, type, t, K, subtitle, 0);
