close all;
clear;
clc;

step_v = 1;
Jx = 1150;
Jy = 1490;
Jz = 890;

Ka = 2;  % [2, 2.2]
Ta = 0.5; % [0.5, 0.6]

t_max = 300;
timestep = 1e-4;
profile = [0 1; t_max 1];

J = Jx;

res = sim("spacecraft.slx");

figure(1);
plot(res.tout, res.out);

entrada = 180/pi;
K = entrada;

num = 1; % Temporario
den = [0 J 0 0]; % Temporario
transfer = tf(num,den);
var = 0.25; % variacao
TaKharitonov = [Ta*(1-var) Ta*(1+var)];
JKharitonov = [J*(1-var) J*(1+var)];
% Função original Ka/[Ta*J J 0 0]
den_min = [TaKharitonov(1)*JKharitonov(1) JKharitonov(1) 0 0];
den_max = [TaKharitonov(2)*JKharitonov(2) JKharitonov(2) 0 0];

[K1, K2, K3, K4] = ConstroiKharitonov(den_min, den_max);

den = [Ta*J J 0 0];
Kk = [den; K1; K2; K3; K4];

transfer = feedback(transfer,(1/entrada));

res = sim("spacecraft.slx");

%% Parametros para simulação
type = "MF";
t = res.tout;
subtitle = "Ângulo [º]";
fontSize = 16;

% Parâmetros de Tuning (ganho K e período T)
tuningParam = [K MF(t, transfer, K, subtitle)];

% Valores dos controladores ([1.123, 5.123, ...], [1.123, 5.123, ...], [1.123, 5.123, ...], ['metodo 1', 'metodo 2', ...]
[KP, TD, TI, Metodos] = PID_Tuning(tuningParam,type);

num = Ka; % Recreando com o atuador
den = [Ta*J J 0 0]; % Recreando com o atuador
Kk(1,:) = den;

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
