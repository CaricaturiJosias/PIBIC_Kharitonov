function [K, tal, T] = MA(t, transfer, subtitle, f_0)
%MA Simulates the step response and analyzes to get the tuning parameters
    fontSize = 18;
    syms s;
    [NUM, DEN] = tfdata(transfer, 'v');
    DEN = [DEN 0];
    %% Calculo dos parametros da reta
    func = vpa(poly2sym(NUM,s)/poly2sym(DEN,s));
    f_t = ilaplace(func);
    f_t_h = matlabFunction(f_t);
    d_1 = diff(f_t);
    d_1_h = matlabFunction(d_1);
    d_2 = diff(d_1);
    d_2_h = matlabFunction(d_2);
    x_sample = fzero(d_2_h, f_0);
    x_sample = find(x_sample >= t, 1 , 'last');
    if ((x_sample < 0) || isempty(x_sample))
        x_sample = find(x_sample > 0, 1 , 'first');
    end
    % Termo dependente
    a = d_1_h(t(x_sample));
    y = f_t_h(t(x_sample));
    % Termo independente
    b = y-a*t(x_sample);
    lin = @(x) a*(x) + b;
    
    % Gerando a reta inteira
    res = lin(t);
    % Procurando o tempo de delay
    val = step(transfer, t);
    
    find(res <= val(x_sample), 1, 'last');
    res_inflex = res(x_sample);
    delay = t(find(res_inflex >= val, 1 ,'last'))-t(x_sample);

    % Corrigindo o delay
    lin = @(x) a*(x-delay) + b;
    res = lin(t);

    %% Caracteristicas da simulação de malha aberta
    % Cálculo do valor e tempo de estabilidade
    stable = val(end);
    % ts = index do tempo (não é o tempo em si)
    ts = t(find(val < (0.98*stable) | val > (1.02*stable), 1, 'last'));

    % Encontrando os parâmetros limites (tempo máximo e mínimo)
    linear_stable = find(res > stable , 1, 'first');
    linear_start = find(res >= 0, 1 ,'first');

    %% Calculo dos últimos itens necessário da simulação de malha fechada
    % Obtendo o ponto igual a 0 e o tempo na reta que fica igual pra igual com 
    % o ponto de estabilidade
    tal_start = roots([a b])+delay;
    tal_end = t(linear_stable);
    if (tal_start <= 0)
        tal_start = 0.01;
    end
    tal = tal_end-tal_start;
    
    % Geração da figura 1
    timestep = t(2)-t(1);
    figure(1);
    plot(tal_start:timestep:tal_end, lin(tal_start:timestep:tal_end));
    hold on;
    plot(t, f_t_h(t));
    hold on;
    plot(t, ones(1,size(t,1)));
    xlabel("Tempo de simulação (s)", 'FontSize', fontSize);
    ylabel(subtitle, 'FontSize', fontSize);
    lgd = legend("Reta no ponto de inflexão", ...
           "Resposta do sistema", ...
           "Degrau de entrada");
    lgd.FontSize = 16;

    % Calculo dos outros parâmetros de estabilidade 
    T = tal_start;
    K = ((stable-0)/(1-0));
    return
end