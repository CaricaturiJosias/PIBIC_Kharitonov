function [ISE, IAE, IATE, MSE, RMSE, IADU, ITSE, ISTE, ITDE, ST, RT, MD, OS] = Performance(Sig_Control, Sig_Exit, Sig_Signal, t)
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
% ISE - No unit
% IAE - No unit
% IATE - No unit
% MSE - No unit
% RMSE - No unit
% IADU - No unit
% ITSE - No unit
% ISTE - No unit
% ST - Seconds
% RT - Seconds
% MD - Unit of the plant output
% OS - Percentage (%)

% This function is made to calculate:

% ISE - integral(e^2)
% Integrated Square error

% IAE - integral(abs(e))
% Integrated Absolute Error

% IATE - integral(t*abs(e))
% Integrated Time Absolute Error

% MSE - (1/t)*integral(t*e^2)
% Mean Squared Error

% RMSE - sqrt((1/t_delta)*integral(t*e^2))
% Root Mean Squared Error

% IADU - integral(differential(e))
% Integral of Absolute Derivative Control Action

% ITSE - integral(t*e^2)
% Integrated Time-weighted Square Error

% ISTE - integral(t^2 * e^2)
% Integral Square time error

% ITDE - integral(sqrt(t*diff(e)))
% Integral Root of Time-weighted Differential Error

% ST
% Settling time

% RT
% Rise Time

% MD 
% Maximum Deviation

% OS
% Overshoot

%% IAE
ISE = 0;
IAE = 0;
IATE = 0;
MSE = 0;
RMSE = 0;
IADU = 0;
ITSE = 0;
ISTE = 0;
ITDE = 0;
timedelta = t(2)-t(1);

for i = 2:size(Sig_Control, 1)
    ISE = ISE + abs(Sig_Control(i)^2);
    IAE = IAE + abs(Sig_Control(i));
    IATE = IATE + abs(t(i)*abs(Sig_Control(i)));
    MSE = MSE  + abs((1/t(i))*(t(i)*Sig_Control(i)^2));
    RMSE = RMSE + abs(sqrt((1/t(i))*(t(i)*Sig_Control(i)^2)));
    IADU = IADU + abs((Sig_Control(i)-Sig_Control(i-1))/timedelta);
    ITSE = ITSE + abs(t(i)*Sig_Control(i)^2);
    ISTE = ISTE + abs(t(i)^2 * Sig_Control(i)^2);
    ITDE = ITDE + abs(sqrt(t(i)*(Sig_Control(i)-Sig_Control(i-1)/timedelta)));
end

ST = t(find((Sig_Exit <= 0.999*Sig_Signal) | (Sig_Exit >= 1.111*Sig_Signal), 1, 'last'));
RT_end = t(find(Sig_Exit <= Sig_Signal, 1, 'last'));
RT_start = t(find(Sig_Exit <= 0.999*Sig_Signal , 1, 'last'));
RT = RT_end - RT_start;
MD = abs(mean(Sig_Exit-Sig_Signal));
OS = abs((max(Sig_Exit)-Sig_Signal(end))*100/Sig_Signal(end));

return;
end