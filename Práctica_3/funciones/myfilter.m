function nI = myfilter(I,H)
%MYFILTER Summary of this function goes here
%   Detailed explanation goes here
    
    % Miramos cuantas filas debemos añadir
    aumento = floor(size(H,1)/2);
    [M,N] = size(I);
    IA = double(I);
    
    % Agregamos primero las filas extras
    IA = [zeros(M,aumento) IA zeros(M,aumento)];
    % Ahora agregamos la columnas extras
    IA = [zeros(aumento,N+aumento*2) ; IA ; zeros(aumento,N+aumento*2)];
    
    % Matriz donde guardar las corrección
    nI = zeros(size(IA,1),size(IA,2));
    
    % Recorremos la matriz y aplicamos la máscara
    for i=1+aumento:M-aumento
        for j=1+aumento:N-aumento
            ventana = IA(i-aumento:i+aumento , j-aumento:j+aumento);
            correccion = ventana.*H;
            nI(i,j) = sum(correccion(:));
        end
    end
    
    %Quitamos los filas de ceros sobrantes
    nI = nI(1+aumento:M-aumento , 1+aumento:N-aumento);
    nI = uint8(nI);
end

