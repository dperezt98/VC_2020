function Ifiltrada = Funcion_FiltroMediana(I,NumFilVent,NumColVent)
%FUNCION_FILTOMEDIANA Summary of this function goes here
%   Detailed explanation goes here
    
    [M,N] = size(I);
    nI = zeros(M,N);
    
    aumento_fil = floor(NumFilVent/2); % Aumento fila 
    aumento_col = floor(NumColVent/2); % Aumento columna
    
    Ia = padarray(I,[aumento_fil aumento_col],'both');
    for i=1+aumento_fil:M+aumento_fil
        for j=1+aumento_col:N+aumento_col
            vent = Ia(i-aumento_fil:i+aumento_fil,j-aumento_col:j+aumento_col);
            nI(i-aumento_fil,j-aumento_col) = median(vent(:));
        end
    end
    
    Ifiltrada = uint8(nI);
end

