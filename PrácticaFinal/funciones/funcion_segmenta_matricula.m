function [detectObj Isegmen] = funcion_segmenta_matricula(Icell,info)
%% FUNCION_SEGMENTA_MATRICULA Localiza los caracteres de una matrícula. Icell
%son las imagenes a segmentar almacenadas en formato de cell. La variable
%info es logica, y si esta a true se mostrará todos todos los procesos que
%se le han hecho a la imagen. La variable Isegmen devuelve las imagenes segmentas
%de cada matrícula. La variable detectObj contiene los centroides y los 
%bounding box de los objetos reconocidos. Las 1 y la 2 columna representan
%las posiciones de X e Y de los centroides. La posiciones 3 y 4 representa 
%los valores de X e Y de la esquina superior del bounding box. Por último, 
%la 5 y la 6 contienen el ancho y el alto del bounding box

    %% 1).- Binarización
    numI = max(size(Icell));
    uX = [];
    mY = [];
    for i=1:numI
        I = Icell{i};
        R{i} = I(:,:,1);

        umbral = graythresh(R{i});
        uX = [uX ; umbral*255]; % valor de X en el umbral
        mY = [mY ; max(imhist(R{i}))]; % valor máximo de un tono de gris
        Rb{i} = imbinarize(R{i},umbral); % Binarizamos la imagen
        
        binary{i,1} = Rb{i}; binary{i,2} = uX;
        if info == true
            disp(['Binarizacion - Imagen ' num2str(i)]);
        end
    end
    
    %% 2).- Eliminación de ruido
    vent = 10;
    for i=1:numI
        Ib = binary{i,1};
        filt{i} = medfilt2(Ib,[vent vent]);
        filt{i} = funcion_invierte_binaria(filt{i});
        if info == true
            disp(['Filtrado - Imagen ' num2str(i)]);
        end
    end
    
    % Eliminamos las zonas conexas muy pequeñas 
    segmen = filt;
    for i=1:numI
        [L,numObj] = bwlabel(filt{i},4); % El 4 representa la vencindad
        for j=1:numObj
            comp = j == L;
            lista(j) = sum(sum(comp));
        end

        umbral = lista(1)*0.20;
        comp = lista < umbral; 
        pos = find(comp); % Tenemos los objetos a borrar en la imagen
        pos = [1 pos]; % El primer objeto tenemos que borrarlo
        for j=1:size(pos,2)
            posBorrado = pos(j) == L;
            segmen{i}(posBorrado) = 0;
        end
        
        if info == true
            disp(['Eliminación de ruido - Imagen ' num2str(i)]);
        end
    end
    
    %% 3).- Seleccion de objetos centrados
    segmenCentrado = segmen;
    for i=1:numI
        [L,numObj] = bwlabel(segmen{i},4);
        M = size(L,1);
        N = size(L,2);
        mitadM = floor(M/2);

        objEliminar = funcion_objetos_no_centrados(L);
        % Sabiendo que objetos tenemos eliminar prodecemos a realizarlo
        if isempty(objEliminar) == 0
            for j=1:size(objEliminar,1)
                posBorrado = objEliminar(j) == L;
                segmenCentrado{i}(posBorrado) = 0;
            end
        else
            segmenCentrado{i} = segmen{i};
        end
        
        if info == true
            disp(['Segmentacion - Imagen ' num2str(i)]);
        end
    end
    
    %% 4).- Busqueda de caracteres
    
    %Para representar de forma más clara las imagenes segmen y
    %segmenCentrado pintaremos los objetos encontrados de verde
    if info==1
       for k=1:numI
           greyColorSegmen = uint8(segmen{k}*255);
           greyColorSegmenCentrado = uint8(segmenCentrado{k}*255);
           [m n] = size(greyColorSegmen);
           nI = cat(3,uint8(zeros(m,n)),greyColorSegmen,uint8(zeros(m,n)));
           segmenColor{k} = nI;
           nI = cat(3,uint8(zeros(m,n)),greyColorSegmenCentrado,uint8(zeros(m,n)));
           segmenCentradoColor{k} = nI;
       end
    end
    
    for i=1:numI
        [L,numObj] = bwlabel(segmenCentrado{i},4);
        M = size(L,1);
        N = size(L,2);
        stats = regionprops('table',L,'Centroid','BoundingBox');
        centroides = table2array(stats(:,1));
        bb = table2array(stats(:,2));
        detectObj{i} = [centroides bb];
        
        if info == true
            lineas_bb = calcula_lineas_bb(bb);
            centroidesX = centroides(:,1);
            centroidesY = centroides(:,2);
            
            figure, hold on, 
                subplot(4,2,1), imshow(Icell{i}), title('Imagen original'),

                subplot(4,2,3), imshow(R{i}), title('Componente roja de la imagen'),
                subplot(4,2,5),imhist(R{i}),line([uX(i) uX(i)],[mY(i) 0],'Color','red'), 
                    title(['Umbral de otsu: ' num2str(uX(i))]),
                subplot(4,2,7), imshow(Rb{i}), title('Imagen binarizada')

                subplot(4,2,2), imshow(filt{i}), title('Imagen filtrada'),

                subplot(4,2,4), imshow(segmenColor{i}), title('Imagen segmentada'),
                subplot(4,2,6), imshow(segmenCentradoColor{i}), title('Imagen segmentada de objetos centrados'),
                    line([0 N],[mitadM mitadM],'Color','blue'),
                subplot(4,2,8), imshow(segmenCentrado{i}), title('Objetos reconocidos'),
                    hold on, 
                    for j=1:size(lineas_bb,2)
                        selec = lineas_bb{j};
                        selecX = selec{1};
                        selecY = selec{2};
                        line(selecX,selecY,'Color','red')
                        hold on, plot(centroidesX,centroidesY,'.r'),
                        sgtitle(['Imagen ' num2str(i)])
                    end
                    hold off; 
        end
        
        if info == true
            disp(['Busqueda de objetos centrados - Imagen ' num2str(i)]);
        end
    end
    
    Isegmen = segmenCentrado;
end

function devolver = calcula_esquina_bb(bb)
%CALCULA_ESQUINA_BB Devuelve una estructura celda en la que cada fila tiene
% 2 columnas. La primera el conjunto de valores de X necesarios para pintar
% el bounding box y la segunda es el conjunto de valores de Y
    devolver = {};
    X = bb(:,1); Y = bb(:,2); ancho = bb(:,3); alto = bb(:,4);
    
    for i=1:size(bb,1)
        
        posX = X(i); posY = Y(i);
        
        %   si = [posX posY]; % Esquina superior izquierda
        %   sd = [posX+mancho posY]; % Esquina superior derecha
        %        
        %   id = [posX+mancho posY+malto]; % Esquina inferior derecha
        %   ii = [posX posY+malto]; % Esquina inferior izquierda
        
        selecX = [posX posX+ancho(i) posX+ancho(i) posX posX];
        selecY = [posY posY posY+alto(i) posY+alto(i) posY];
        devolver{i} = {selecX selecY};
    end
end

function nI = funcion_invierte_binaria(I)
%FUNCION_INVIERTE_BINARIA Intercambia los valores '0' por '1' y los valores
% '1' por '0' de una matriz
    nI = I;
    valor0 = 0 == I; 
    valor1 = 1 == I;
    nI(valor0) = 1; nI(valor1) = 0;
    nI = logical(nI);
end

function objEliminar = funcion_objetos_no_centrados(L)
%FUNCION_OBJETOS_NO_CENTRADOS Le pasamos una matriz L con los objetos de la
%imagen etiquetados, y la función se encarga de devolver los objetos que no
%están centrados en la misma
    M = size(L,1);
    mitadM = floor(M/2);
    
    % Seleccionamos la línea central de la imagen
    selecLinea = L(mitadM,:);
    
    % Ahora comprobamos que objetos se encuentran en la misma
    comp = unique(selecLinea);
    
    % Eliminamos los objetos que están en la posición central
    objetos = unique(L);
    binCompGlobal = false(size(objetos,1),size(objetos,2));
    for j=1:size(comp,2)
        binComp = objetos == comp(j);% binaria comprueba
        binCompGlobal = binCompGlobal+binComp;
    end
    binObjEliminar = funcion_invierte_binaria(binCompGlobal);
    objEliminar = objetos(binObjEliminar);
end



