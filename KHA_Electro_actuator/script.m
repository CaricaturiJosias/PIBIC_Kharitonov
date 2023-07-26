close all;
clear;
clc;

syms s k;

fontSize = 12;
t_max = 40;
timestep = t_max/1e6;
step_v = 1;

% Use symbolics to simulate state transfer 
% with the commented out code further ahead
Ra = 7.5; 
La = 0.067; 
Ce = 0.129; % syms 
Ca = 4.125; % syms 
Ja = 0.06; % syms 
Bt = 0.03; % syms 

% syms La;
% syms Ra; 
% syms Ce;
% syms Ca;
% syms Ja;
% syms Bt;

%% Função de transferência e ganho no limite da estabilidade
num = [(1419+80*Ra) (80*Ra + 1419) (80*Ra + 1419)];
den = [160*La (160*Ra + 80*La) (80*Ra + 1419) 0];

% Variação de 25%
variacao = 0.25;
RaKharitonov = [Ra*(1-variacao), Ra*(1+variacao)];
LaKharitonov = [La*(1-variacao), La*(1+variacao)];
den_min = [160*LaKharitonov(1) (160*RaKharitonov(1) + 80*LaKharitonov(1)) (80*RaKharitonov(1) + 1419) 0];
den_max = [160*LaKharitonov(2) (160*RaKharitonov(2) + 80*LaKharitonov(2)) (80*RaKharitonov(2) + 1419) 0];

[K1, K2, K3, K4] = ConstroiKharitonov(den_min, den_max);

Kk = [den; K1; K2; K3; K4];

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

%% To obtain the Kharitonov numerator and 
% denominator run the code below with symbolics for Ra and La
% --------------------------------
% Phi=inv(s*eye(3)-A);
% 
% H=C*Phi*B+D;
% 
% %Display
% pretty(simplify(H));
% 
% %% --------------------------------

[NUM,DEN] = ss2tf(A,B,C,D); % DOESNT USE SYMBOLIC

transfer = tf(NUM,DEN);
K = routh(transfer);
K = sym2poly(K(1));
transfer = feedback(transfer*K, 1);

% Simulink scenario

res = sim("actuator.slx");

%% Simulation parameters
type = "MA";
subtitle = "Angular velocity (rad/s)";
MF_K = 0;
t = res.tout;
f_0 = 0;

% Tuning parameters (gain K and period T)
[K, tal, T] = MA(t, transfer, subtitle, f_0);
tuningParam = [K, tal, T];

% Controler Values ([1.123, 5.123, ...], [1.123, 5.123, ...], [1.123, 5.123, ...], ['metodo 1', 'metodo 2', ...]
[KP, TD, TI, Metodos] = PID_Tuning(tuningParam,type);

% List size for performance parameters
sizeArray = size(KP,2);

QntKharitonov = size(Kk, 1);

% Create empty lists of size sizeArray 
[ITAE, MSE, ST, RT] = deal(zeros(QntKharitonov, sizeArray));

% Empty list of stable and unstable methods
[Not_used , Used] = deal(strings(QntKharitonov,sizeArray));
poli = ["nominal", "K1", "K2", "K3", "K4"];

for j = 1:QntKharitonov
    transfer = tf(num, Kk(j, :));
    figure(1+j);
    %% Simulation of every PID method
    for i = 1:sizeArray
        % Valores do PID para o index i
        [Kp, Td, Ti] = deal(KP(i),TD(i),TI(i));
        % Simular planta com o controlador e obter a estabilidade
        % res -> out (valores), tout (tempo de simulação)
        [stable, res] = PID_Execution(transfer,Kp, Ti, Td, t);
        % É estável? 
        if (stable < 0)
            % É estável, apresentar a simulação e guardar o nome do método na
            % lista de estáveis
            Used(j,i) = Metodos(i);
            % Simulação do método
            plot(res.tout, res.out, 'DisplayName', Used(i));
            hold on; 
            % Salvar valores calculados para cada critério de desempenho
            % Com os dados da simulação
            [ ITAE(j,i), MSE(j,i),  ...
               ST(j,i),   RT(j,i),  ...
            ] = ... 
            ... 
            Performance(res.c_t, res.out, res.tout);
    
        % Instável
        else 
            % Salvar nome do método não usado
            Not_used(j,i) = Metodos(i);
        end % else
    end % for i = 1:sizeArray
    %% Detalhes do plot
    % Plotar sinal de entrada - Degrau
    plot(t, t>0);
    % Parâmetros do gráfico - textos e legenda
    title(sprintf("Simulação de resposta ao degrau do polinômio %s", poli(j)));
    xlabel("Tempo de simulação (s)", 'FontSize',fontSize);
    ylabel(subtitle);
    % Used - lista de métodos
    UsedLine = Used(j, :);
    legendText = [UsedLine(~cellfun(@isempty,cellstr(UsedLine))) "Degrau de entrada"];
    
    lgd = legend(legendText);
    lgd.NumColumns = 3;
    lgd.FontSize = 12;
end % for i = 1:QntKharitonov

%% Limpar espaços vazios nas listas
% ex: 13 métodos de MA, 8 usados, existem 5 espaços vazios em cada lista
% pois sizeArray = 13

[Used, Not_used, KP_Clear, TD_Clear, TI_Clear, ...
    ITAE, MSE, ST, RT] =    ...
...
ClearOutput(Used, Not_used, KP, TD, TI, ITAE, MSE, ST, RT);
%% Geração da tabela de dados
[resultTable] = ...
...
FormatTable(Used, KP_Clear, TD_Clear, TI_Clear, ...
            ITAE, MSE, ST, RT);

%% Utilização da tabela paralela
ParallelCoords(resultTable, QntKharitonov);

disp("Métodos não utilizados");
disp(Not_used);

