function devolver = calcula_esquina_bb(bb)
%CALCULA_ESQUINA_BB Devuelve una estructura celda en la que cada fila tiene
% 2 columnas. La primera el conjunto de valores de X necesarios para pintar
% el bounding box y la segunda es el conjunto de valores de Y. bb es el
% bounding box de un objeto 
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

