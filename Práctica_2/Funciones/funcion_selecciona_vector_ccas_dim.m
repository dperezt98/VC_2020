function [espacioCcas, JespacioCcas] = funcion_selecciona_vector_ccas_dim(XoI,YoI,numDescriptoresOI,dimensiones)
%FUNCION_SELECCIONA_VECTOR_CCAS_3_DIM Summary of this function goes here
%   Detailed explanation goes here
     numDescriptores = size(XoI,2);
    
    % 1.- Cuantificación individual de características
    output = YoI';
    valores = zeros(1,numDescriptores);
    
    for i=1:numDescriptores
        input = XoI(:,i)';
        valores(1,i) = indiceJ(input,output);
    end
    
    % 2.- Pre-selección de características
    [~,valoresOrdenados] = sort(valores,'descend'); % El primer valor será el más grande
    valoresSeleccionados = valoresOrdenados(1:numDescriptoresOI);
    
    % 3.- Selección final de características
    combinaciones = combnk(valoresSeleccionados,dimensiones); %Todas las posibles combinaciones entre los descriptores seleccionados
    numCombinaciones = size(combinaciones,1);
    
    valores = zeros(numCombinaciones,1);
    
    for i=1:numCombinaciones
        COI = combinaciones(i,:); % Cogemos una combinación de descriptores
        input = XoI(:,COI)'; % Cogemos todos los valores de esos descriptores
        valores(i) = indiceJ(input,output); % Calculamos su J
    end
    
    [valoresOrdenados, indice] = sort(valores,'descend');
    
    espacioCcas = combinaciones(indice(1),:);
    JespacioCcas = valoresOrdenados(1);
end