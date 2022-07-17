function Ib = funcion_mascaraUmbral(I,umbral)
%FUNCION_MASCARAUMBRAL función que suma el valor de las componentes R, G y
%B de I y selecciona los píxeles que estén por encima del umbral
    
    [M,N,n] = size(I);
    Id = double(I);

    % Sumamos el valor de cada canal de la imagen en una sola matriz
    matriz = zeros(M,N);
    
    for i=1:3
        matriz = matriz + Id(:,:,i);
    end
    
    Ib = matriz > umbral;
end

