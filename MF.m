function [T] = MF(t,transfer, K, subtitle)
%MF Gets the parameter for closed loop and prints the step response
    fontSize = 18;
    syms s;
    transfer = feedback(transfer*K,1);
    
    figure(1);
    [out ,tout] = step(transfer, t(end));
    plot(tout, out);
    xlabel("Tempo de simulação (s)", 'FontSize', fontSize);
    ylabel(subtitle, 'FontSize', fontSize);
    hold on;
    plot (tout, ones(size(tout,1),1));
    [NUM, DEN] = tfdata(transfer);
    func = vpa(poly2sym(cell2mat(NUM),s)/poly2sym(cell2mat(DEN),s));
    lgd = legend("Resposta do sistema", "Degrau de entrada");
    lgd.FontSize = 16;
    f_t = ilaplace(func);
    f_t_h = matlabFunction(f_t);

    %% Gerando a função inteira
    x_ft = f_t_h(t);
    [peaks, ~] = findpeaks(x_ft,t);
    [peaks_n, ~] = findpeaks(-1*x_ft, t);
    
    if size(peaks, 1) > size(peaks_n, 1)
        peaks = peaks(1:size(peaks));
    end
    t_peaks = zeros(size(peaks,1));
    
    %% Obtem o período médio
    for i = 1:size(peaks,1)
        t_peaks(i) = t(find(x_ft == peaks(i, 1), 1, 'first'));
    end

    T_half = zeros(size(t_peaks,2));
    for i = 1:size(t_peaks,2)
        if i ~= 1
            T_half(i) = t_peaks(i, 1) - t_peaks(i-1, 1);
        end
    end
    T = mean(T_half(2:end, 1));
    return
end