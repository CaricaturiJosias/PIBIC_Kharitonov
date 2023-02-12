function [K] = routh(transfer)
%routh Checks if the transfer function is stable
    syms s Kp;

    [num, den] = tfdata(transfer, 'v');
    
    func = poly2sym(num,s)*Kp/poly2sym(den,s);

    func = func/(1+func);

    func = simplify(func);
    
    [~, den] = numden(func);

    R = coeffs(poly2sym(den, s),s);
    nbrCoeffs = size(R, 2);

    if (rem(nbrCoeffs, 2) == 0) % Numero par de coeficientes
        if (nbrCoeffs > 2)
            RT = [R(1,nbrCoeffs:-2:1) 0 0;
                  R(1,(nbrCoeffs-1):-2:1) 0 0];
        else % tem 2 coeficientes
            RT = [R(1,2) R(1,1) 0;
                  0      0      0];
        end
    else    % Numero impar de coeficientes
        RT = [R(1,nbrCoeffs    :-2:1) 0;
              R(1,(nbrCoeffs-1):-2:1) 0 0];
    end

    b1 = simplify((RT(2,1)*RT(1,2)-RT(1,1)*RT(2,2))/RT(2,1));
    b2 = (RT(2,1)*RT(1,3)-RT(1,1)*RT(2,3))/RT(2,1);
    b3 = 0;
    c1 = (b1*RT(2,2)-RT(2,1)*b2)/b1;
    c2 = (b1*RT(2,3)-RT(2,1)*b3)/b1;
    c3 = 0;
    d1 = (c1*b2-b1*c2)/c1;
    d2 = (c1*b3-b1*c3)/c1;
    d3 = 0;

    K1 = vpasolve(b1, Kp);
    K2 = vpasolve(c1, Kp);
    K3 = vpasolve(d1, Kp);
    K = -K1;
end