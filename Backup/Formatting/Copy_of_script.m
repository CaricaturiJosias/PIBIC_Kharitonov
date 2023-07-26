clear;
close all;
clc;

t_max = 0.1;
timestep = t_max/10000;
step_v = 1000;
time = 0:timestep:t_max;

fontSize = 16;

R = 21.2;
Kb = 0.1433;
D = 1e-4;
L = 0.052;
Kt = 0.1433;
J = 1e-5;

num = Kt*Kb;
den = [(L*J) (L*D+R*J) Kt*Kb];
sim("bldc_2016_mamf.slx");

% TODO - Mudanças temporárias, serão justificadas futuramente
RaKharitonov = [20, 30];
LaKharitonov = [0.03 0.07];
den_min = [J*LaKharitonov(1) (LaKharitonov(1)*D + RaKharitonov(1)*J) (Kt*Kb)];
den_max = [J*LaKharitonov(2) (LaKharitonov(2)*D + RaKharitonov(2)*J) (Kt*Kb)];

[K1, K2, K3, K4] = ConstroiKharitonov(den_min, den_max);

Kk = [K1; K2; K3; K4];

transfer = tf(num, den);
[num, den] = tfdata(transfer, 'v');

%% Parametros para simulação
type = "MA";
subtitle = "Velocidade angular (rad/s)";
MF_K = 0;
t = tout;
f_0 = 0;

% Parâmetros de Tuning (ganho K e período T)
[K, tal, T] = MA(t, transfer, subtitle, f_0);
tuningParam = [K, tal, T];

% Valores dos controladores ([1.123, 5.123, ...], [1.123, 5.123, ...], [1.123, 5.123, ...], ['metodo 1', 'metodo 2', ...]
[KP, TD, TI, Metodos] = PID_Tuning(tuningParam,type);

% Tamanho das listas para parametros de desempenho
sizeArray = size(KP,2);

QntKharitonov = size(Kk, 1);

% Criar listas vazias com tamanho sizeArray 
[ISE ,IAE ,ITAE , ...
 MSE ,RMSE ,IADU , ...
 ITSE ,ISTE ,ITDE , ...
 ST ,RT ,MD ,OS] = deal(zeros(QntKharitonov, sizeArray));

% Lista vazia de métodos estáveis e instáveis
[Not_used , Used] = deal(strings(QntKharitonov,sizeArray));
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
            [ ISE(j,i),  IAE(j,i), ITAE(j,i), ...
              MSE(j,i), RMSE(j,i), IADU(j,i), ...
             ITSE(j,i), ISTE(j,i), ITDE(j,i), ...
               ST(j,i),   RT(j,i),   MD(j,i), ...
               OS(j,i)] = ... 
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
    xlabel("Tempo de simulação (s)", 'FontSize',fontSize);
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

[Used, Not_used, KP_Clear, TD_Clear, TI_Clear, ISE, IAE, ITAE, MSE, RMSE,   ...
    IADU, ITSE, ISTE, ITDE, ST, RT, MD, OS] =    ...
...
ClearOutput(Used, Not_used, KP, TD, TI, ISE, IAE, ITAE, ...
    MSE, RMSE, IADU, ITSE, ISTE, ITDE, ST, RT, MD, OS);

%% Geração da tabela de dados
for i = 1:size(QntKharitonov)
    [resultTable] = ...
    ...
    FormatTable(Used, KP_Clear, TD_Clear, TI_Clear, ...
                ISE(i, :), IAE(i, :), ITAE(i, :), MSE(i, :), RMSE(i, :), ...
                IADU(i, :), ITSE(i, :), ISTE(i, :), ITDE(i, :), ST(i, :), ...
                RT(i, :), MD(i, :), OS(i, :));
end
%% Utilização da tabela paralela
ParallelCoords(resultTable);

disp("Métodos não utilizados");
disp(Not_used);
