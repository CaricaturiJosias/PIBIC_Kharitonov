function [ITAE, MSE, ST, RT] = Performance(Sig_Control, Sig_Exit, t)
% ISE, IAE,  RMSE, IADU, ITSE, ISTE, ITDE, MD, OS
%Performance Gets the total for each of the defined performance parameters
% Details -------------------------------------------------------------------
% Gets a list of values that will be manipulated to obtain the values that
% represent each of the performance parameters for the simulated system
% Arguments: 
% Sig_Control - Control signal
% Sig_Exit - Plant output
% Sig_Signal - Input signal (Expected to be a vector of the same size of the other inputs)
% t - Time values used for the Sig_Control and Sig_Exit conversation 
% Return values:

% ITAE - No unit
% MSE - No unit

% ST - Seconds
% RT - Seconds

% This function is made to calculate:

% ITAE - integral(t*abs(e))
% Integrated Time Absolute Error

% MSE - (1/t)*integral(t*abs(e))
% Mean Squared Error

% ST
% Settling time

% RT
% Rise Time

[ITAE,MSE] = deal(0);
timedelta = t(2)-t(1);

for i = 2:size(Sig_Control, 1)
    ITAE = ITAE + abs(t(i)*abs(Sig_Control(i)));
    MSE = MSE  + abs((1/t(i))*(t(i)*Sig_Control(i)^2));
end

% Sinal de entrada (degrau por padrão)
Sig_Signal = t>0;

ST = t(find((Sig_Exit <= 0.98*Sig_Signal) | (Sig_Exit >= 1.1*Sig_Signal), 1, 'last'));
RT_end = t(find(Sig_Exit <= Sig_Signal, 1, 'last'));
RT_start = t(find(Sig_Exit >= 0.1*Sig_Signal , 1, 'first'));
RT = RT_end - RT_start;

return;
end