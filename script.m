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
d = 0.5;
T = 1/330e3;
RE = R*Rsc/(R+Rsc);

A = [   (((d-1)*(RC1+RS2+RE)-(RL1+RB+d*RS1))/L1)      ((d-1)*(RS2+RE)-d*RS1)/L1                 (d-1)/L1    (d-1)*RE/L1;
        ((d-1)*(RS2+RE)-d*RS1)/L2                     ((d-1)*(RS2+RE)-(d*RC1+RL2+d*RS1))/L2     d/L2        (d-1)*RE/L2;
        (d-1)/C1                                      -d/C1                                     0           0;
        (d-1)*RE/Csc                                  (d-1)*RE/Csc                              0           -1/(Csc*(Rsc+R))];

B = [1/L1; 0; 0; 0];

C = [-(d-1)*R/(R+Rsc)   -(d-1)*R/(R+Rsc)   0    -1/(R+Rsc);
      (d-1)*RE           (d-1)*RE          0    R/(R+Rsc) ];

D = [0; 0];

I = eye(size(A,1));

test = (C*((s*I - A)^-1))*B;
Test1 = test(1);
Test2 = test(2);

Test1 = simplify(Test1);
Test2 = simplify(Test2);

[num1, den1] = numden(Test1);
num1 = sym2poly(num1);
den1 = sym2poly(den1);

[num2, den2] = numden(Test2);
num2 = sym2poly(num2);
den2 = sym2poly(den2);

transf1 = tf(num1, den1);

resp = ss2tf(A,B,C,D);

transferS = tf(resp(2,:), resp(1,:));

transfer = transferS;

[num, den] = tfdata(transf1, 'v');

syms k;
func = poly2sym(num*k,s)/poly2sym(den,s);

func = func/(1+func);
func = simplify(func);
[~, denK] = numden(func);

 denK = coeffs(denK, s);
 
 a0 = denK(1);
 a1 = denK(3);
 a2 = denK(2);
 a3 = denK(4);
 
 b1 = (a1*a2 - a0*a3)/a1 == 0;
 b1 = simplify(b1);
 Ka = solve(b1, k);
 Kb = solve(a3>0, k);

[num, den] = tfdata(transf1, 'v');
transfer = tf(num*sym2poly(Kb), den);
transfer = feedbad