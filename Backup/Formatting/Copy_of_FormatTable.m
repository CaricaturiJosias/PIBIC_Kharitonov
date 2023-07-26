function [ResultTable] = ...
            FormatTable(Used, KP, TD, TI, ...
            ITAE, MSE, ST, RT)

% ISE, IAE, RMSE, IADU, ITSE, ISTE, ITDE, MD, OS
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    pidValuesText = strings(size(KP, 2),1);
    % Geração dos textos com os valores dos controladores PID
    for i = 1:size(KP, 2)
        pidValuesText(i) = sprintf("%.4f || %.4f || %.4f",...
                           KP(i), TD(i), TI(i));
    end
    
    % Colunas da tabela a ser gerada
    Colunas = ["Métodos", "P-I-D", ...
               "ITAE","MSE","ST","RT"];

    % "IAE", "RMSE", "IADU","ITSE","ISTE","ITDE","MD","OS"

    % A tabela de resultados tem todos os métodos estáveis
    % em conjunto com todos os parâmetros de desempenho
    ResultTable = cell(size(Used, 2)+1, size(Colunas, 2));

    ResultTable(1,:) = num2cell(Colunas);
    ResultTable(2:end,1) = num2cell(Used);
    ResultTable(2:end,2) = num2cell(pidValuesText);
    % ResultTable(2:end,3) = num2cell(ISE);
    % ResultTable(2:end,4) = num2cell(IAE);
    ResultTable(2:end,3) = num2cell(ITAE);
    ResultTable(2:end,4) = num2cell(MSE);
    % ResultTable(2:end,7) = num2cell(RMSE);
    % ResultTable(2:end,8) = num2cell(IADU);
    % ResultTable(2:end,9) = num2cell(ITSE);
    % ResultTable(2:end,10) = num2cell(ISTE);
    % ResultTable(2:end,11) = num2cell(ITDE);
    ResultTable(2:end,5) = num2cell(ST);
    ResultTable(2:end,6) = num2cell(RT');
    % ResultTable(2:end,14) = num2cell(MD');
    % ResultTable(2:end,15) = num2cell(OS');
    ResultTable

end