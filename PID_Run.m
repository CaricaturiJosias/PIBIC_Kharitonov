function PID_Run(transfer, type, t, MF_K, subtitle)
%PID_RUN Run the entire PID execution script
%   Runs all the functions necessary
%   transfer - transfer function of the plant
%   type - "MA" for open loop or "MF" for closed loop
%   t - time that will be used for the simulation
%   MF_K (0 if not closed loop) - Value for closed loop oscilation gain
%   Subtitle - Text to be shown in the Y axis of the graphs (Varies, X is
%   always seconds)
    fname = "[PID_Run]";
    
    % Prepare the time
    t_max = t(end);
    
    % Define The non pid parameters
    if (type == "MA")
        [K, tal, T] = MA(t, transfer, subtitle);
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
            Used(i) = Metodos(i);
            plot(res.tout, res.out, 'DisplayName', Used(i));
            hold on; 
            input = ones(size(res.tout,1),1);
            [ISE(i), IAE(i), IATE(i), MSE(i), RMSE(i), IADU(i), ITSE(i), ISTE(i), ITDE(i), ST(i), RT(i), MD(i), OS(i)] = Performance(res.c_t, res.out, input, res.tout);
        else 
            Not_used(i) = Metodos(i);
        end
    end
    title("Todos os metodos PID que possuem estabilidade");
    xlabel("Tempo de simulação (s)");
    ylabel(subtitle);
    hold off;
    lgd = legend;
    lgd.NumColumns = 3;

    % Clear the output
    [Used, Not_used, ISE, IAE, IATE, MSE, RMSE,   ...
     IADU, ITSE, ISTE, ITDE, ST, RT, MD, OS] =    ...
     ...
     Clear_Output(Used, Not_used, ISE, IAE, IATE, ...
     MSE, RMSE, IADU, ITSE, ISTE, ITDE, ST, RT, MD, OS);
    
    legend(Used);

    figure(3);
    Table = table(ISE,IAE,IATE,MSE,RMSE,IADU,ITSE,ISTE,ITDE,ST,RT,MD,OS,'RowNames',cellstr(Used));
    uitable('Data',Table{:,:},'ColumnName',Table.Properties.VariableNames,...
    'RowName',Table.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);

    fig = uifigure;
    T = table(Not_used');
    uitable(fig, 'Data', T, 'ColumnName', "Unstable methods");
    writetable(Table,'PERFORMANCE.xlsx','Sheet',1)
end