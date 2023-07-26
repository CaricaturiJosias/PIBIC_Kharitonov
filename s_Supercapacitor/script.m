close all;
clear;
clc;

step_v = 1;
t_max = 1000;
timestep = t_max/1e6;

syms s;

format long;

Rsc = 3.2e-3;
RC1 = 10e-3;
RS1 = 10e-3;
RS2 = 10e-3;
RL1 = 10e-3;
RL2 = 10e-3;
RB = 70e-3;
Csc = 350;
L1 = 10e-6;
L2 = 10e-6;
C1 = 820e-6;
R = 0.54;
syms d;
% d = 0.5;
T = 1/330e3;
RE = R*Rsc/(R+Rsc);

A = [   (((d-1)*(RC1+RS2+RE)-(RL1+RB+d*RS1))/L1)      ((d-1)*(RS2+RE)-d*RS1)/L1                 (d-1)/L1    (d-1)*RE/L1;
        ((d-1)*(RS2+RE)-d*RS1)/L2                     ((d-1)*(RS2+RE)-(d*RC1+RL2+d*RS1))/L2     d/L2        (d-1)*RE/L2;
        (d-1)/C1                                      -d/C1                                     0           0;
        (d-1)*RE/Csc                                  (d-1)*RE/Csc                              0           -1/(Csc*(Rsc+R))];
d1 = d*T;
A1 = [   (((d1-1)*(RC1+RS2+RE)-(RL1+RB+d1*RS1))/L1)      ((d1-1)*(RS2+RE)-d1*RS1)/L1                 (d1-1)/L1    (d1-1)*RE/L1;
        ((d1-1)*(RS2+RE)-d1*RS1)/L2                     ((d1-1)*(RS2+RE)-(d1*RC1+RL2+d1*RS1))/L2     d1/L2        (d1-1)*RE/L2;
        (d1-1)/C1                                      -d1/C1                                     0           0;
        (d1-1)*RE/Csc                                  (d1-1)*RE/Csc                              0           -1/(Csc*(Rsc+R))];
d2 = T;
A2 = [   (((d2-1)*(RC1+RS2+RE)-(RL1+RB+d2*RS1))/L1)      ((d2-1)*(RS2+RE)-d2*RS1)/L1                 (d2-1)/L1    (d2-1)*RE/L1;
        ((d2-1)*(RS2+RE)-d2*RS1)/L2                     ((d2-1)*(RS2+RE)-(d2*RC1+RL2+d2*RS1))/L2     d2/L2        (d2-1)*RE/L2;
        (d2-1)/C1                                      -d2/C1                                     0           0;
        (d2-1)*RE/Csc                                  (d2-1)*RE/Csc                              0           -1/(Csc*(Rsc+R))];

A = laplace(A);
A1 = laplace(A1);

B = [1/L1; 0; 0; 0];

C = [-(d-1)*R/(R+Rsc)   -(d-1)*R/(R+Rsc)   0    -1/(R+Rsc);
      (d-1)*RE           (d-1)*RE          0    R/(R+Rsc) ];

C1 = [-(d1-1)*R/(R+Rsc)   -(d1-1)*R/(R+Rsc)   0    -1/(R+Rsc);
      (d1-1)*RE           (d1-1)*RE          0    R/(R+Rsc) ];
C2 = [-(d2-1)*R/(R+Rsc)   -(d2-1)*R/(R+Rsc)   0    -1/(R+Rsc);
      (d2-1)*RE           (d2-1)*RE          0    R/(R+Rsc) ];

C = laplace(C);
C1 = laplace(C1);

D = [0; 0];

I = eye(size(A,1));

Bd = (A1-A2)+B;
Ed = (C1-C2)+D;

syms s;
Phi=det(inv(s*eye(4)-A));
H=C/Phi/Bd+Ed;

resp = ss2tf(A,B,C,D);

transferS = tf(resp(2,:), resp(1,:));

transfer = -transferS;

[num, den] = tfdata(transfer, 'v');
step(transfer);

figure();
[r,k] = rlocus(transfer);
rlocus(transfer); % Gerar o gráfico
[z, p, kP] = tf2zp(num, den);

% Extrair melhor valor do root locus
% Remove o infinito dos ganhos
x = ~isinf(k);
k = k(x);
r = r(x);

limit_index = find(real(r(1,:))<0, 1, 'last');
K_MF = k(limit_index);

figure();
transferMF = K_MF*transfer;
transferMF = feedback(transferMF,1);
step(transferMF);

res = sim("no_pid.slx");
figure();
plot(res.tout, res.out);

% [K, tal, T] = MA(res.tout, transfer);
