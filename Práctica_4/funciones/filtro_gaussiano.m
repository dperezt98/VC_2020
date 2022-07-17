function Ifiltrada = filtro_gaussiano(I,ventana,desv)
%FILTRO_GAUSSIANO Summary of this function goes here
%   Detailed explanation goes here

    M = zeros(ventana, ventana);
    mitadV = floor(ventana/2);
    
    posX = -mitadV:mitadV;
    posY = -mitadV:mitadV;
    
    for i=1:ventana
        for j=1:ventana
            M(i,j) = exp( -0.5*(posX(i)^2 + posY(j)^2)/desv^2); 
        end
    end
    
    h = (1/sum(M(:)))*M;
    
    Ifiltrada = imfilter(I,h);
end

