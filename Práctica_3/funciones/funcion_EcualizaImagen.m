function Ieq = funcion_EcualizaImagen(I,modo)
%FUNCION_ECUALIZAIMAGEN Función para ecualizar de forma uniforma una
%imagen, donde I es la imagen de entrada y Ieq la imagen de salida
%ecualizada. Esta función puede implementarse según diferentes criterios:
%-1: Implementación píxel a píxel de la imagen y calcular la función de
%transformación para cada píxel para generar la imagen de salida
%-2: Realizar el cálculo de la función de transformaicón para cada nivel de
%gris posible y, recorriendo la imagen píxel a píxel, aplicarla para
%generar la imagen de salida.
%-3: Realizar el cálculo de la función de transformación para cada nivel de
%gris posible y, haciendo bariido en los 256 posibles nivels de gris,
%aplicarla para generar la imagen de salida.

    [M,N] = size(I);
    L = 256; % Número de niveles de grises
    H = funcion_HistAcum(imhist(I)); % Histograma acumulado de I
    Ieq = zeros(M,N); % Matriz de salida
    Id = double(I);
    
    switch modo
        case 1 % Recorrido píxel a píxel
            for i=1:M
                for j=1:N
                    g = Id(i,j);
                    Ieq(i,j) = funcion_transformacion(H(g+1),M,N,L); % Al pasarle g debemos sumar 1 porque MATLAB empieza en 1 el array
                end
            end
            
        case 2 % Calculamos la funcion de transformacion para cada nivel de gris, después recorremos la imagen
            transformacion = funcion_transformacion(H,M,N,L); 
            for i=1:M
                for j=1:N
                    Ieq(i,j) = transformacion(Id(i,j)+1); 
                end
            end
            
        case 3 % Calculamos la funcion de transformacion para cada nivel de gris, hacemos barrido en los 256 niveles de gris
            transformacion = funcion_transformacion(H,M,N,L); 
            for i=1:256
               Ib = I == i-1;
               Ieq(Ib) = transformacion(i);
            end
        otherwise
            "Introduzca una modo válido"
    end

    Ieq = uint8(Ieq);
end

function gprima = funcion_transformacion(H,M,N,L)
%     gprima = max(0, round(L/(M*N) * H(:))-1);
    gprima = round((L-1)/(M*N) * H(:));
end

