function H = funcion_HistAcum(h)
%FUNCION_HISTACUM Calcula el histograma acumulado de una imagen a partir de
%su hisgrama h
    
    [M,N] = size(h);
    num_elementos = max([M,N]);
    H = zeros(size(h));
    acumulado = 0;
    for i=1:num_elementos
        acumulado = acumulado + h(i);
        H(i) = acumulado;
    end
end

