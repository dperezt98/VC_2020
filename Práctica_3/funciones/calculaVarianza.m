function varianza = calculaVarianza(I)
%CALCULAVARIANZA Calcula la varianza de una imagen
    
    [M,N] = size(I);
    brillo = calculaBrillo(I);
    varianza = sum((I(:)-brillo).^2) / (M*N);
end

function brillo = calculaBrillo(I)
%CALCULABRILLO Calcula el brillo de una imagen

    [M,N] = size(I);
    brillo = sum(I(:)) / (M*N);
end
