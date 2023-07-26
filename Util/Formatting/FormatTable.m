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
               "ITAE ","MSE ","ST ","RT "];

    subColunas = ["", "K^{1}", "K^{2}", "K^{3}", "K{4}"];
    sizeSub = size(subColunas,2);
    
    default = Colunas(1:2);
    colunasAjustadas = strings(1,(size(Colunas, 2)-2)*sizeSub);
    for i = 1:(size(Colunas, 2)-2)
        for j = 1:sizeSub
            colunasAjustadas((i-1)*sizeSub+j) = strcat(...
                                            Colunas(i+2), ...
                                            subColunas(j));
        end
    end
    Colunas = [default colunasAjustadas];
    % A tabela de resultados tem todos os métodos estáveis
    % em conjunto com todos os parâmetros de desempenho
    ResultTable = cell(size(Used, 2)+1, size(Colunas, 2));

    ResultTable(1,:) = num2cell(Colunas);
    ResultTable(2:end,1) = num2cell(Used);
    ResultTable(2:end,2) = num2cell(pidValuesText);
    
    CurrentColumn = 3;
    ResultTable(2:end,CurrentColumn:(CurrentColumn+sizeSub-1)) = num2cell(ITAE');
    
    CurrentColumn = CurrentColumn + sizeSub;
    ResultTable(2:end,CurrentColumn:(CurrentColumn+sizeSub-1)) = num2cell(MSE');

    CurrentColumn = CurrentColumn + sizeSub;
    ResultTable(2:end,CurrentColumn:(CurrentColumn+sizeSub-1)) = num2cell(ST');

    CurrentColumn = CurrentColumn + sizeSub;
    ResultTable(2:end,CurrentColumn:(CurrentColumn+sizeSub-1)) = num2cell(RT');

end