function Ieq_local = funcion_EcualizaLocal(I,NumFilVent,NumColVent,OpcionRelleno)
%FUNCION_ECUALIZALOCAL Función para ecualizar de forma local, a nivel de
%píxel una imagen. donde I es la imagen de entrada, NumFilVent y NumColVent
%son el número de filas y columnas de la ventana de vecindad y opción de
%relleno permitirá aplicar "symmetric", "replicate" o "zeros" xomo opciones
%de relleno a todos aquerllos píxeles que no existen en la imagen, pero
%puedan incluirse en el entornod e vencidad de los píxeles del o cercanos
%al contorno de la imagen.
    
    [M,N] = size(I);
    
    aumento_fil = floor(NumFilVent/2); % Aumento fila 
    aumento_col = floor(NumColVent/2); % Aumento columna
    
    % Comprobamos que sea un número de filas impar
    if rem(NumFilVent,2) == 0
        aumento_fil = aumento_fil + 1;
    end
    
    if rem(NumColVent,2) == 0
        aumento_fil = aumento_fil + 1;
    end

    posfil = aumento_fil+1; % posición central de la ventana en fila
    poscol = aumento_col+1; % posición central de la ventana en columna
    
    Ia = I;     
    
    switch OpcionRelleno
        % Rellenamos la imagen con padarray
        case "symmetric"
            Ia = padarray(I,[aumento_fil aumento_col],'symmetric','both');
        case "replicate"
            Ia = padarray(I,[aumento_fil aumento_col],'replicate','both');
        case "zeros"
            Ia = [zeros(aumento_fil,N) ; Ia ; zeros(aumento_fil,N)]; % Agregamos primero las filas extras  
            Ia = [zeros(M+aumento_fil*2,aumento_col) Ia zeros(M+aumento_fil*2,aumento_col)]; % Ahora agregamos la columnas extras
        
%         % Rellenamos la imagen con código propio
%         case "symmetric" % Hace la un ejecto de espejo a la imagen
%             % Cogemos la parte superior y la inferior
%             zona_superior = Ia(1:aumento_fil,1:N);
%             zona_superior = flip(zona_superior);
%             
%             % La invertimos
%             zona_inferior = Ia(M-aumento_fil:M,1:N);
%             zona_inferior = flip(zona_inferior);
%             
%             Ia = [zona_superior;Ia;zona_inferior];
%            
%             % Repetimos con las el lado izquierda y la derecha
%             zona_izquierda = Ia(1:end,1:aumento_col);
%             zona_derecha = Ia(1:end,N-aumento_col:N);
%             
%             zona_izquierda = flip(zona_izquierda,2); % El 2 para invertir por columna
%             zona_derecha = flip(zona_derecha,2); % El 2 para invertir por columna
%             
%             Ia = [zona_izquierda Ia zona_derecha];
%             
%         case "replicate" % Coge la primera fila y la replica hacia arriba. Lo mismo con la fila conlindante en el resto de direcciones
%             fila_superior = Ia(1,1:N); % Replicamos la fila superior
%             fila_inferior = Ia(M,1:N); % Replicamos la fila inferior
%             % Para repetir una fila usamos la funcion repmat(fila_superior,aumento_fila,1)
%             % Le indicamos el vector a replicar, el número de repeticiones
%             % en filas, y el número de repeticiones en columnas
%             
%             zona_superior = repmat(fila_superior, aumento_fil,1);
%             zona_inferior = repmat(fila_inferior, aumento_fil,1);
%             
%             Ia = [zona_superior ; Ia ; zona_inferior];
%             
%             columna_izq = Ia(1:end,1); % Replicamos la columna izquierda
%             columna_der = Ia(1:end,N); % Replicamos la columna derecha
%             
%             zona_izquierda = repmat(columna_izq, 1, aumento_col);
%             zona_derecha = repmat(columna_der, 1, aumento_col);
%             
%             Ia = [zona_izquierda Ia zona_derecha];
        
        otherwise
            disp("Introduzca una opción de relleno válida: 'symmetric', 'replicate' o 'zeros'");
    end

    Ieq_local = zeros(M,N);
    
    for i=1+aumento_fil:M+aumento_fil
        for j=1+aumento_col:N+aumento_col
            % Seleccionamos el trozo de la Ia a ecualizar
            selec = Ia(i-aumento_fil:i+aumento_fil,j-aumento_col:j+aumento_col); 
            % Ecualizamos el fragmento seleccionado
            Ieq = funcion_EcualizaImagen(selec,2);
            % Guardamos el píxel central de la ventana en la imagen final
            Ieq_local(i-aumento_fil,j-aumento_col) = Ieq(posfil,poscol);
        end
    end
    
    Ieq_local = uint8(Ieq_local);
end

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
    gprima = round((L-1)/(M*N) * H(:));
end

