function [Kp, Td, Ti, Metodos] = PID_Tuning(Tuning_Param,Type)
%PID_Tuning Gets the PID control parameters for each of the methods
% Details ------------------------------------------------------------------
% Gets the PID parameters for each method described ahead based on direct
% control analysis of the step response of the system

% Open Loop (MA)
    if strcmp('MA', Type)
        % ==============================================
        % ================= P, PI and PID ==============
        K   = Tuning_Param(1);
        tal = Tuning_Param(2);
        T   = Tuning_Param(3);
%         "ZN"                   "Parr"          "Chidambaram" ...
%                    "Borresen and Grindal" "Murrill"       "Lipták"      ...
%                    "Alfaro Ruiz"          "Alfaro Ruiz 2" "PMA"         ...
%                    "PMA 2"                "Chien"         "Chien 2"     ...
%         
        Metodos = ["ZNMA"      "ParrMA" "ChiMA"  ...
                   "Bor&GriMA" "MurMA"  "LipMA"  ...
                   "AlfMA1"    "AlfMA2" "PmaMA1" ...
                   "PmaMA2"    "CHMA1"  "CHMA2"  ...
                   "CCMA"];
        Kp = zeros(1,size(Metodos,2));
        Td = zeros(1,size(Metodos,2));
        Ti = zeros(1,size(Metodos,2));
        
        %% ============ PID - ZN
        Kp(1) = 1.2*tal/T;
        Ti(1) = 2*T;
        Td(1) = 0.5*T;

        %% ============ PID - Parr
        Kp(2) = (1.25*tal)/(K*T);
        Ti(2) = 2.5*T;
        Td(2) = 0.4*T;
        
        %% ============ PID - Chidambaram
        Kp(3) = (1/K)*(1.8*(tal/T)+0.45);
        Ti(3) = 2.4*T;
        Td(3) = 0.38*T;
        
        %% ============ PID - Borresen and Grindal
        Kp(4) = tal/(K*T);
        Ti(4) = 3*T;
        Td(4) = 0.5*T;
        
        %% ============ PID - Murrill
        Kp(5) = (1.37/K)*((tal/T)^0.95);
        Ti(5) = (tal/1.351)*((T/tal)^0.738);
        Td(5) = 0.365*tal*((T/tal)^0.95);
        
        %% ============ PID - Lipták
        Kp(6) = 0.85*tal/(K*T);
        Ti(6) = 1.6*T;
        Td(6) = 0.6*T;
        
        %% ============ PID - Alfaro Ruiz
        Kp(7) = 3.3*tal/(K*T);
        Ti(7) = 2.5*T;
        Td(7) = 0.4*T;
        %% ============ PID - Alfaro Ruiz 2
        Kp(8) = (1.2/K)*(1.56*(tal/T)+0.68);
        Ti(8) = (tal*(2.5+0.957*(T/tal)))/(1+0.787*(T/tal));
        Td(8) = (tal*(0.4+0.153*(T/tal)))/(1+0.787*(T/tal));
        
        %% ============ PID - PMA
        Kp(9) = 0.59*tal/(K*T);
        Ti(9) = 2*T;
        Td(9) = 2*T;
        
        %% ============ PID - PMA 2
        Kp(10) = 0.59*tal/(K*T);
        Ti(10) = 2*T;
        Td(10) = T;
        
        %% ============ PID - Chien
        Kp(11) = 0.95*tal/(K*T);
        Ti(11) = 2.38*T;
        Td(11) = 0.42*T;
        
        %% ============ PID - Chien 2
        Kp(12) = 1.2*tal/(K*T);
        Ti(12) = 2*T;
        Td(12) = 0.42*T;
        
        %% ============ PID - Cohen and Coon
        Kp(13) = (1/K)*(1.35*(tal/T)+0.25);
        Ti(13) = tal*((2.5*(T/tal)+0.46*(T/tal)^2))/(1+0.61*(T/tal));
        Td(13) = (0.37*T)/(1+0.19*(T/tal));
        return
    end
    %% Closed Loop (MF)
    if strcmp('MF', Type)
        K = Tuning_Param(1);
        T = Tuning_Param(2);
%         Metodos = ["ZN"                 "Farrington"           "McAvoy and Johnson"   ...
%                    "Atkinson and Davey" "Carr and Pettit"      "Carr and Pettit 2"    ...
%                    "Parr"               "Parr 2"               "Parr 3"               ...
%                    "Tinham"             "Blickley"             "Corripio"             ...
%                    "Chen and Yang"      "De Paor"              "De Paor 2"            ...
%                    "McMillan"           "McMillan 2"           "Calcev and Gorez"     ...
%                    "Luo et al"          "Karaboga and Kalinli" "Belanger and Luyben " ...
%                    "Wojsznis"           "Yu"                   "Robbins"              ...
%                    "Smith"];
        Metodos = ["ZNMF"                 "FarrMF"           "Mc&JoMF" ...
                   "Atk&DavMF" "Car&PetMF1"      "Car&PetMF2"  ...
                   "ParrMF1"               "ParrMF2"               "ParrMF3"             ...
                   "TinMF"             "BliMF"             "CorrMF"           ...
                   "Ch&YaMF"      "DPaMF1"              "DPaMF2"          ...
                   "McMiMF1"           "McMiMF2"           "Ca&GoMF"   ...
                   "LuoMF"          "Kar&KalMF" "Bel&LuyMF"  ...
                   "WojMF"           "YuMF"                   "RobMF"            ...
                   "SmiMF"];

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

        %% ============ PID - McAvoy and Johnson
        Kp(3) = 0.54*K;
        Ti(3) = T;
        Td(3) = 0.2*T;

        %% ============ PID - Atkinson and Davey
        Kp(4) = 0.25*K;
        Ti(4) = 0.75*T;
        Td(4) = 0.25*T;

        %% ============ PID - Carr and Pettit
        Kp(5) = 0.667*K;
        Ti(5) = T;
        Td(5) = 0.167*T;

        %% ============ PID - Carr and Pettit 2
        Kp(6) = 0.5*K;
        Ti(6) = 1.5*T;
        Td(6) = 0.167*T;

        %% ============ PID - Parr
        Kp(7) = 0.5*K;
        Ti(7) = T;
        Td(7) = 0.2*T;

        %% ============ PID - Parr 2
        Kp(8) = 0.5*K;
        Ti(8) = T;
        Td(8) = 0.25*T;

        %% ============ PID - Parr 3
        Kp(9) = 0.5*K;
        Ti(9) = 0.34*T;
        Td(9) = 0.08*T;
        
        %% ============ PID - Tinham
        Kp(10) = 0.4444*K;
        Ti(10) = 0.6*T;
        Td(10) = 0.19*T;
  
        %% ============ PID - Blickley
        Kp(11) = 0.5*K;
        Ti(11) = T;
        Td(11) = 0.125*T;

        %% ============ PID - Corripio
        Kp(12) = 0.75*K;
        Ti(12) = 0.63*T;
        Td(12) = 0.1*T;

        %% ============ PID - Chen and Yang
        Kp(13) = 0.27*K;
        Ti(13) = 2.4*T;
        Td(13) = 1.32*T;

        %% ============ PID - De Paor
        Kp(14) = 0.906*K;
        Ti(14) = 0.5*T;
        Td(14) = 0.125*T;

        %% ============ PID - De Paor 2
        Kp(15) = 0.866*K;
        Ti(15) = 0.5*T;
        Td(15) = 0.125*T;

        %% ============ PID - McMillan
        Kp(16) = 0.5*K;
        Ti(16) = 0.5*T;
        Td(16) = 0.125*T;

        %% ============ PID - McMillan 2
        Kp(17) = 0.3*K;
        Ti(17) = 0.5*T;
        Td(17) = 0.125*T;

        %% ============ PID - Calcev and Gorez
        Kp(18) = 0.3536*K;
        Ti(18) = 0.1592*T;
        Td(18) = 0.0398*T;

        %% ============ PID - Luo et al
        Kp(19) = 0.48*K;
        Ti(19) = 0.5*T;
        Td(19) = 0.125*T;

        %% ============ PID - Karaboga and Kalinli
        Kp(20) = 0.32*K;
        Ti(20) = 0.213*T;
        Td(20) = 0.133*T;

        %% ============ PID - Luyben and Luyben
        Kp(21) = 0.46*K;
        Ti(21) = 2.2*T;
        Td(21) = 0.16*T;

        %% ============ PID - Wojsznis
        Kp(22) = 0.4*K;
        Ti(22) = 0.333*T;
        Td(22) = 0.083*T;

        %% ============ PID - Yu
        Kp(23) = 0.33*K;
        Ti(23) = 0.5*T;
        Td(23) = 0.125*T;

        %% ============ PID - Robbins
        Kp(24) = 0.45*K;
        Ti(24) = 0.5*T;
        Td(24) = 0.25*T;

        %% ============ PID - Smith
        Kp(25) = 0.75*K;
        Ti(25) = 0.625*T;
        Td(25) = 0.1*T;
        return
    end
end