function Ifiltrada = Funcion_FiltroMinimos(I)
%FUNCION_FILTOMEDIANA Summary of this function goes here
%   Detailed explanation goes here
    
    [M,N] = size(I);
    nI = zeros(M,N);
    
    aumento_fil = 1; % Aumento fila 
    aumento_col = 1; % Aumento columna
    
    Ia = padarray(I,[aumento_fil aumento_col],'both');
    for i=1+aumento_fil:M+aumento_fil
        for j=1+aumento_col:N+aumento_col
            vent = Ia(i-aumento_fil:i+aumento_fil,j-aumento_col:j+aumento_col);
            nI(i-aumento_fil,j-aumento_col) = min(vent(:));
        end
    end
    
    Ifiltrada = uint8(nI);
end

