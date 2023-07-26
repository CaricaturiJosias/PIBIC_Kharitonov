close all;
clear;
clc;

%% Massa
% Toneladas (1g * 10^6)
Mi = [784 543 485 430 ...
      377 326 278 231 ... 
      187 174 161 149 ...
      138 126 122 117 ...
      112 107 103 49]*1e3;

Mt = sum(Mi);

% Toneladas (1g * 10^6)
mi = [0        0        0        0        ...
      0        0        0        0        ...
      0        0        0        0        ...
      0        0        6.137    0        ...
      0        93.775   0        99.98]*1e3;

mt = sum(mi);

Ma = [Mi mi];

Ms = diag(Ma);

%% Formato modal (Phi)
% Acima de 90%
Phi = ((-5 + (5+5)*rand(1,size(mi,2)))+90)/100;

%% Frequência de tuning
% rad/sec

wui =[0        0        0        0        ...
      0        0        0        0        ...
      0        0        0        0        ...
      0        0        7.915    0        ...
      0        2.036    0        1.760];


%% Robustez
% Robustez 10^11 N/m
Ki = [0.16 8.20 0.14 7.11 ...
      0.12 6.13 0.10 5.25 ...
      0.09 4.58 0.08 4.08 ...
      0.07 3.61 0.06 3.18 ...
      0.05 2.79 0.02 1.30]*1e11;

ki = zeros(1,size(wui, 2));
for i = 1:size(ki,2)
    ki(1,i) = mt/(1/(wui(1,i)^2));
end

Ks = [
      diag(Ki) zeros(size(Ki,2)); 
      zeros(size(Ki,2)) zeros(size(Ki,2))
     ] + [
      diag(ki) -flip(diag(ki)); 
      -flip(diag(ki))' diag(ki)
     ];

%% Proporção da massa

miI = zeros(1,size(mi, 2));
for i = 1:size(mi,2)
    miI(1,i) = mi(1,i)/(Mt);
end


%% Amortecimento
%  10^3 N*s/m
Lambda = 0.05;

Zetad = ones(1, size(mi,2));
for i = 1:size(Zetad,2)
    Zetad(1,i) = Phi(i)*((Lambda/(1+mi(i)))+sqrt(mi(i)/(1+mi(i))));
end

ci = ones(1, size(mi,2)); 
for i = 1:size(ci,2)
    ci(i) = 2*Zetad(i)*mi(i)*wui(i);
end

%% Wind values
p = 1.2; % kg/m^3
Cd = 1;

%% Diametro do andar (m)
D = [ 20.0  19.5  19.0  18.5 ...
      18.0  17.5  17.0  16.5 ...
      16.0  15.5  15.0  14.5 ...
      14.0  13.5  13.0  12.5 ...
      12.0  11.5  11.0  10.5];

%% Altura do andar (m)
H = [ 012.5  025.0  037.5  050.0 ...
      062.5  075.0  087.5  100.0 ...
      112.5  125.0  137.5  150.0 ...
      162.5  175.0  187.5  200.0 ...
      212.5  225.0  237.5  250];

%% Área efetiva
Ai = ones(1,size(D,2));
for i = 1:size(Ai,2)
    Ai(i) = D(i)*H(i);
end

%% Velocidade do vento

U = [ 31.5 35.0 37.0 39.0 ...
      41.5 42.5 43.5 44.0 ...
      45.0 46.0 46.5 47.0 ...
      47.5 48.0 48.5 49.0 ...
      49.5 50.0 51.0 51.0];

%% Simulação do vento

fullMatFileName = fullfile('wind_simu.mat');
if ~exist(fullMatFileName, 'file')
  message = sprintf('%s does not exist', fullMatFileName);
  uiwait(warndlg(message));
else
  s = load(fullMatFileName);
end

%% Matriz de amortecimento Cs
% C =   miI*Mi + Lambda*Ki
Cs = zeros(1,size(U,2));
for i = 1:size(Cs,2)
    Cs(i) = miI(i)*Mi(i) + Lambda*Ki(i);
end
Cs = [
      diag(Cs) zeros(size(Cs,2)); 
      zeros(size(Cs,2)) zeros(size(Cs,2))
     ] + [
      diag(ci) -flip(diag(ci)); 
      -flip(diag(ci))' diag(ci)
     ];

%% Valores de origem (Profile)
Fi = zeros(1,size(U, 2));

for i = 1:size(Fi,2)
    Fi(i) = p*Cd*Ai(i)*U(i);
end

t_max = s.t_scale(end);
timestep = s.t_scale(2)-s.t_scale(1);

t = 1:timestep:t_max;

Test = Fi(2)*(s.Y_speed(:,1));

% for i = 2:size(Fi,2)
%     Test = Fi(i)*(s.Y_speed(:,i));
%     figure(i);
%     plot(s.t_scale, Test);
%     title_name = sprintf("Wind force on the %dth floor",i);
%     title(title_name);
%     ylabel("[N]");
%     xlabel("[s]");
% end
% k = 1;
% dx^2*Ms dx*Cs Ks
syms s;
figure(1)
% for i = 1:size(Ms,2)
    num = 1;
    den = [Ms(40,40) Cs(40,40) Ks(40,40)];
%     if any(den)
        
%       k = k+1;
        transfer = tf(num,den);
        num = routh(transfer);
        transfer = tf(num,den);
        transfer = feedback(transfer, 1);
        step(transfer);
        hold on;
%     end
% end

