function [Kp, Td, Ti, Metodos] = PID_Tuning(Tuning_Param,Type)
%PID_Tuning Gets the PID control parameters for each of the methods
% Details ------------------------------------------------------------------
% Gets the PID parameters for each method described ahead based on direct
% control analysis of the step response of the system

% Open Loop (MA)
    % Se for malha aberta (Type == 'MA')
    if strcmp('MA', Type)
        % ==============================================
        % ================= P, PI and PID ==============
        % Variáveis para essa simulação
        K   = Tuning_Param(1);
        tal = Tuning_Param(2);
        T   = Tuning_Param(3);
        % "ZNMA"      "ParrMA"        "ChiMA"  ...
        % "Bor&GriMA" "MurMA"         "LipMA"  ...
        % "AlfMA1"    "AlfMA2"        "PmaMA1" ...
        % "PmaMA2"    "CHMA1"         "CHMA2"  ...
        % "CCMA"
        Metodos = ["ZNMA"      "ChiMA"  "MurMA"  ...
                   "CCMA"];
        % Inicialização de listas para acomodar todos os valores de cada
        % componente dos controladores
        Kp = zeros(1,size(Metodos,2));
        Td = zeros(1,size(Metodos,2));
        Ti = zeros(1,size(Metodos,2));
        
        % Obtenção de todos os valores para os 12 métodos de controle
        % descritos em Metodos
        %% ============ PID - ZN
        Kp(1) = 1.2*tal/T;
        Ti(1) = 2*T;
        Td(1) = 0.5*T;

        %% ============ PID - Chidambaram
        Kp(2) = (1/K)*(1.8*(tal/T)+0.45);
        Ti(2) = 2.4*T;
        Td(2) = 0.38*T;
        
        %% ============ PID - Murrill
        Kp(3) = (1.37/K)*((tal/T)^0.95);
        Ti(3) = (tal/1.351)*((T/tal)^0.738);
        Td(3) = 0.365*tal*((T/tal)^0.95);

        %% ============ PID - Cohen and Coon
        Kp(4) = (1/K)*(1.35*(tal/T)+0.25);
        Ti(4) = tal*((2.5*(T/tal)+0.46*(T/tal)^2))/(1+0.61*(T/tal));
        Td(4) = (0.37*T)/(1+0.19*(T/tal));
        return

    end
    %% Closed Loop (MF)
    if strcmp('MF', Type)
        K = Tuning_Param(1);
        T = Tuning_Param(2);
%         Metodos = ["ZNMF"      "FarrMF"      "Mc&JoMF"    ...
%                    "Atk&DavMF" "Car&PetMF1"  "Car&PetMF2" ...
%                    "ParrMF1"   "ParrMF2"     "ParrMF3"    ...
%                    "TinMF"     "BliMF"       "CorrMF"     ...
%                    "Ch&YaMF"   "DPaMF1"      "DPaMF2"     ...
%                    "McMiMF1"   "McMiMF2"     "Ca&GoMF"    ...
%                    "LuoMF"     "Kar&KalMF"   "Bel&LuyMF " ...
%                    "WojMF"     "YuMF"        "RobMF"      ...
%                    "SmiMF"];
        Metodos = ["ZNMF"      "FarrMF"     "Ch&YaMF" ...
                   "LuoMF"];

        Kp = zeros(1,size(Metodos,2));
        Td = zeros(1,size(Metodos,2));
        Ti = zeros(1,size(Metodos,2));

        %% ============ PID - ZN
        Kp(1) = 0.6*K;
        Ti(1) = 0.5*T;
        Td(1) = 0.125*T;

        %% ============ PID - Farrington
        Kp(2) = 0.33*K;
        Ti(2) = T;
        Td(2) = 0.1*T;

        %% ============ PID - Chen and Yang
        Kp(3) = 0.27*K;
        Ti(3) = 2.4*T;
        Td(3) = 1.32*T;

        %% ============ PID - Luo et al
        Kp(4) = 0.48*K;
        Ti(4) = 0.5*T;
        Td(4) = 0.125*T;

        return
    end
end