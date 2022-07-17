function brillo = calculaBrillo(I)
%CALCULABRILLO Calcula el brillo de una imagen
    [M,N] = size(I);
    brillo = sum(I(:)) / (M*N);
end

