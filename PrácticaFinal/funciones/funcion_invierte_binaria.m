function nI = funcion_invierte_binaria(I)
%FUNCION_INVIERTE_BINARIA Intercambia los valores '0' por '1' y los valores
% '1' por '0' de una matriz lógica
    nI = I;
    valor0 = 0 == I; 
    valor1 = 1 == I;
    nI(valor0) = 1; nI(valor1) = 0;
    
    nI = logical(nI);
end

