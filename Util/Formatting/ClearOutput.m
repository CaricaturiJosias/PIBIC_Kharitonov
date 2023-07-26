function [Clear_Used, Clear_Unused, KP, TD, TI, IATE, MSE, ST, RT] = ClearOutput(Used, Unused, KP, TD, TI, IATE, MSE, ST, RT)
%CLEAR_OUTPUT Gets all the parameters for the stable functions
%   Uses the empty spaces in Used to now which performance metrics from the
%   arrays to ignore and set arrays with all the necessary values for
%   displaying

% The methods in blank were 'not used'/'used' respectively
UsedIndex = ~cellfun(@isempty,cellstr(Used));
UsedAux = Used(1,:);

UsedFinal = zeros(1,size(UsedIndex,2));

% Transform all into a single line (all 4 are stable at this one)
for i = 1:size(UsedIndex, 2)
    UsedFinal(i) = all(UsedIndex(:,i));
end

fprintf("Métodos utilizados: %d", sum(UsedFinal == 1));
UsedFinal = logical(UsedFinal);

Clear_Used = UsedAux(UsedFinal);
Clear_Unused = UsedAux(~UsedFinal);

KP = real(KP(UsedFinal)); 
TD = real(TD(UsedFinal)); 
TI = real(TI(UsedFinal)); 

IATE = real(IATE(:,UsedFinal));
% IATE = IATE(:, any(IATE, 1));
% IATE = IATE(any(IATE, 2), :);

MSE = real(MSE(:,UsedFinal));
% MSE = MSE(:, any(MSE, 1));
% MSE = MSE(any(MSE, 2), :);

ST = real(ST(:,UsedFinal));
% ST = ST(:, any(ST, 1));
% ST = ST(any(ST, 2), :);

RT = real(RT(:,UsedFinal));
% RT = RT(:, any(RT, 1));
% RT = RT(any(RT, 2), :);
end