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

addpath(genpath('Util'));

close all;
clear;
clc;

syms k;
fontSize = 16;

%% Parâmetros do simulink
t_max = 2;
timestep = t_max/1e6;
step_v = 1;

%% Planta
Kb = 1.2;
J = 0.022;
B = 5e-4;
La = 0.035;
Ra = 2.45;

%% Função de transferência e ganho no limite da estabilidade
num = Kb;
den = [J*La (Ra*J+B*La) (Ra*B+Kb^2) 0];
transfer = tf(num,den);

vari = 0.25;
RaKharitonov = [Ra*(1-vari) Ra*(1+vari)];
LaKharitonov = [La*(1-vari) La*(1+vari)];
den_min = [J*LaKharitonov(1) (RaKharitonov(1)*J+B*LaKharitonov(1)) (RaKharitonov(1)*B+Kb^2) 0];
den_max = [J*LaKharitonov(2) (RaKharitonov(2)*J+B*LaKharitonov(2)) (RaKharitonov(2)*B+Kb^2) 0];

[K1, K2, K3, K4] = ConstroiKharitonov(den_min, den_max);

Kk = [den; K1; K2; K3; K4];

A = (J*B*Ra^2 + Ra*J*Kb^2 + Ra*La*B^2 + La*B*Kb^2 - J*La*k*Kb)/(Ra*J+B*La);
K = -sym2poly(routh(transfer));

%% Simu para tempo

res = sim("DC_2016.slx");

%% Parametros para simulação
type = "MF";
t = res.tout;
subtitle = "Velocidade do eixo (rad/s)";

% Parâmetros de Tuning (ganho K e período T)
tuningParam = [K MF(t, transfer, K, subtitle)];

% Valores dos controladores ([1.123, 5.123, ...], [1.123, 5.123, ...], [1.123, 5.123, ...], ['metodo 1', 'metodo 2', ...]
[KP, TD, TI, Metodos] = PID_Tuning(tuningParam,type);

% Tamanho das listas para parametros de desempenho
sizeArray = size(KP,2);

QntKharitonov = size(Kk, 1);

% Criar listas vazias com tamanho sizeArray
[ITAE, MSE, ST, RT] = deal(zeros(QntKharitonov, sizeArray));

% Lista vazia de métodos estáveis e instáveis
[Not_used , Used] = deal(strings(QntKharitonov,sizeArray));
poli = ["nominal", "K1", "K2", "K3", "K4"];

for j = 1:QntKharitonov
    transfer = tf(num, Kk(j, :));
    % Simulação por método de controle PID
    figure(1+j);
    %% Simulação de cada método
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
     ITAE, MSE,  ST, RT] =    ...
...
ClearOutput(Used, Not_used, KP, TD, TI, ...
            ITAE, MSE, ST, RT);

%% Geração da tabela de dados
[resultTable] = ...
...
FormatTable(Used, KP_Clear, TD_Clear, TI_Clear, ...
            ITAE, MSE, ST, RT);

%% Utilização da tabela paralela
ParallelCoords(resultTable, QntKharitonov);
