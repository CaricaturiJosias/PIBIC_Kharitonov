function [K1,K2,K3,K4] = ConstroiKharitonov(In_min,In_max)
%ConstroiKharitonov Constroi um denominador/Numerador de Kharitonov
%   Cálcula as 4 variações de uma função de transferência com base no
%   numerador ou denominador, se forem os 2, haveriam 16 variações, isso
%   para funções de transferência considerando 2 variações

% Polinômios de Kharitonov
    % In_min e In_max vão ser tratados como uma matriz como as
    % representadas a seguir:
    % Num_min=flip([1.8 0.8 1.4]);
    % Num_max=flip([4.2 1.2 2.6]);
    
    Num_min=flip(In_min);
    Num_max=flip(In_max);

    K_even_max=[];
    K_even_min=[];
    K_odd_max=[];
    K_odd_min=[];
    
    size_num=size(Num_min,2);
    j=1;k=1;
    for i=1:size_num
        if mod(i,2)~=0 %pares
            if mod(j,2)~=0
                K_even_max=cat(2,K_even_max,Num_max(i));
                K_even_min=cat(2,K_even_min,Num_min(i));
                K_odd_max=cat(2,K_odd_max,1);
                K_odd_min=cat(2,K_odd_min,1);
                j=j+1;
            else
                K_even_max=cat(2,K_even_max,Num_min(i));
                K_even_min=cat(2,K_even_min,Num_max(i));
                K_odd_max=cat(2,K_odd_max,1);
                K_odd_min=cat(2,K_odd_min,1);
                j=j+1;
            end
        else
            if mod(k,2)~=0
                K_even_max=cat(2,K_even_max,1);
                K_even_min=cat(2,K_even_min,1);
                K_odd_max=cat(2,K_odd_max,Num_max(i));
                K_odd_min=cat(2,K_odd_min,Num_min(i));
                k=k+1;
            else
                K_even_max=cat(2,K_even_max,1);
                K_even_min=cat(2,K_even_min,1);
                K_odd_max=cat(2,K_odd_max,Num_min(i));
                K_odd_min=cat(2,K_odd_min,Num_max(i));
                k=k+1;     
            end
        end
    end
    
    K1=flip(K_even_min.*K_odd_min);
    K2=flip(K_even_min.*K_odd_max);
    K3=flip(K_even_max.*K_odd_min);
    K4=flip(K_even_max.*K_odd_max);
end