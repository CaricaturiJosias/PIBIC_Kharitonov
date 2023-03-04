function [Clear_Used, Clear_Unused, KP, TD, TI, ISE, IAE, IATE, MSE, RMSE, IADU, ITSE, ISTE, ITDE, ST, RT, MD, OS] = Clear_Output(Used, Unused, KP, TD, TI, ISE, IAE, IATE, MSE, RMSE, IADU, ITSE, ISTE, ITDE, ST, RT, MD, OS)
%CLEAR_OUTPUT Gets all the parameters for the stable functions
%   Uses the empty spaces in Used to now which performance metrics from the
%   arrays to ignore and set arrays with all the necessary values for
%   displaying

% The methods in blank were 'not used'/'used' respectively
Used_index = ~cellfun(@isempty,cellstr(Used));
Clear_Used = Used(Used_index);
Clear_Unused = Unused(~Used_index);

KP = real(KP(Used_index)); 
TD = real(TD(Used_index)); 
TI = real(TI(Used_index)); 
ISE = real(ISE(Used_index)); 
IAE = real(IAE(Used_index)); 
IATE = real(IATE(Used_index)); 
MSE = real(MSE(Used_index)); 
RMSE = real(RMSE(Used_index)); 
IADU = real(IADU(Used_index)); 
ITSE = real(ITSE(Used_index)); 
ISTE = real(ISTE(Used_index)); 
ITDE = real(ITDE(Used_index)); 
ST = real(ST(Used_index)); 
RT = real(RT(Used_index)); 
MD = real(MD(Used_index)); 
OS = real(OS(Used_index)); 
end