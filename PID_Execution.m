function [stable, result] = PID_Execution(transfer,Kp, Ti, Td, t_max)
%PID_Execute Execute the PID simulation
%   Uses the PID parameters coupled with the transfer function to simulate
%   The execution of the plant with a step until the time t_max
    CS = tf(Kp,1) + tf(Kp,[Ti 0]) + tf([Kp*Td 0],1);
    loop = feedback(transfer*CS,1);
    stable = max(real(eig(loop)));
    result = 0;
    if (stable > 0)
        return; % unstable
    else
        result = struct('out', [], 'tout', [], 'c_t', []);
        [result.out, result.tout] = step(loop,t_max);
        result.c_t = 1-result.out;
    end
    return
end