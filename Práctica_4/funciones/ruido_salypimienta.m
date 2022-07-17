function nI = ruido_salypimienta(I,p,q)
%SALYPIMIENTA Corrompe la imagen I con ruido de tipo sal y pimienta. La
%imagen resultante se devuelve en la variable nI siendo q-p el porcentaje 
% de píxeles con ruido de tipo pimienta y 1-q el porcentaje de píxeles con 
% ruido detipo sal
    
    % Creamos una nueva imagen a modificar
    nI = I;
    
    % Creamos una matriz del mismo tamaño que I y le damos valores entre 0 y 1
    % Comprobamos los valores entre p <= x < q. Los píxeles que cumplan la
    % condición serán sustituidos por valor 0 en la imagen nI
    [M,N] = size(I);
    randM = rand(M,N);
    Ib = (p <= randM) & (randM < q);
    nI(Ib) = 0; % Tipo pimienta
    
    % Hacemos lo mismo pero ahora comprobamos los valores entre q <= x < 1
    Ib = (q <= randM) & (randM < 1);
    nI(Ib) = 255; % Tipo sal
end

