function PID_Run(transfer, type, t, MF_K, subtitle, f_0)
%PID_RUN Run the entire PID execution script
%   Runs all the functions necessary
%   transfer - transfer function of the plant
%   type - "MA" for open loop or "MF" for closed loop
%   t - time that will be used for the simulation
%   MF_K - (0 if not closed loop) - Value for closed loop oscilation gain
%   Subtitle - Text to be shown in the Y axis of the graphs (Varies, X is
%   always seconds)
%   f_0 - In case the inflexion point in an open loop is not detected
%   correctly, insert an number that can be used as a reference
    fname = "[PID_Run]";
    fontSize = 16;
    % Prepare the time
    t_max = t(end);
    
    % Define The non pid parameters
    if (type == "MA")
        [K, tal, T] = MA(t, transfer, subtitle, f_0);
        Tuning_Param = [K, tal, T];
        
    elseif (type == "MF")
        Tuning_Param = [MF_K MF(t, transfer, MF_K, subtitle)];
    else
        fprintf("%s Something is wrong", fname);
        return;
    end

    % Define the tuning parameters
    [KP, TD, TI, Metodos] = PID_Tuning(Tuning_Param,type);
    size_Array = size(KP,2);
    ISE = zeros(size_Array,1);
    IAE = zeros(size_Array,1);
    IATE = zeros(size_Array,1);
    MSE = zeros(size_Array,1);
    RMSE = zeros(size_Array,1);
    IADU = zeros(size_Array,1);
    ITSE = zeros(size_Array,1);
    ISTE = zeros(size_Array,1);
    ITDE = zeros(size_Array,1);
    ST = zeros(size_Array,1);
    RT = zeros(size_Array,1);
    MD = zeros(size_Array,1);
    OS = zeros(size_Array,1);

    Not_used = strings(1,size_Array);
    Used = strings(1,size_Array);
    figure(2);
    for i = 1:size_Array
        Kp = KP(i);
        Td = TD(i);
        Ti = TI(i);
        [stable, res] = PID_Execution(transfer,Kp, Ti, Td, t_max);
        if (stable < 0)
            t_ref = res.tout;
            Used(i) = Metodos(i);
            plot(res.tout, res.out, 'DisplayName', Used(i));
            hold on; 
            input = ones(size(res.tout,1),1);
            [ISE(i), IAE(i), IATE(i), MSE(i), RMSE(i), IADU(i), ITSE(i), ISTE(i), ITDE(i), ST(i), RT(i), MD(i), OS(i)] = Performance(res.c_t, res.out, input, res.tout);
        else 
            Not_used(i) = Metodos(i);
        end
    end
    hold on;
    % Clear the output
    [Used, Not_used, ISE, IAE, IATE, MSE, RMSE,   ...
     IADU, ITSE, ISTE, ITDE, ST, RT, MD, OS] =    ...
     ...
     Clear_Output(Used, Not_used, KP, TD, TI, ISE, IAE, IATE, ...
     MSE, RMSE, IADU, ITSE, ISTE, ITDE, ST, RT, MD, OS);

    plot(t_ref, ones(1,size(t_ref,1)));
    xlabel("Tempo de simulação (s)", 'FontSize',fontSize);
    legendText = [Used "Degrau de entrada"];
    lgd = legend(legendText);
    lgd.NumColumns = 3;
    lgd.FontSize = 12;

    ISE = ISE';
    IAE = IAE';
    IATE = IATE';
    KP = arrayfun(@(a)num2str(round(a, 3)),KP,'uni',0);
    TD = arrayfun(@(a)num2str(round(a, 3)),TD,'uni',0);
    TI = arrayfun(@(a)num2str(round(a, 3)),TI,'uni',0);
    espaco = cell(1, size(Used,2));
    espaco(:) = {' || '};
    PID = string(strcat(KP, espaco, TD, espaco, TI))';
    
    Method = cellstr(Used)';
    Table = table(Method, PID, ISE, IAE, IATE, MSE, RMSE, IADU, ...
                  ITSE, ISTE, ITDE, ST, RT, MD, OS);
    
    writetable(Table,'PERFORMANCE.xlsx','Sheet',1)
end