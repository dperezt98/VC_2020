function nI = amplitudContraste(I,q)
%AMPLITUDCONTRASTE Amplia el contraste de la imagen especificando el nivel
%máximo y mínimo(qmax y qmin) de gris que se desea obtener en la nueva imagen
    
    % Tenemos la fórmula: q(x,y) = qmin +
    % ((qmax-qmin)/(pmax-pmin))*(p(x,y)-pmin))
    qmax = max(q); qmin = min(q);
    pmax = max(I(:)); pmin = min(I(:));
 
    % Comprobamos que qmax y qmin están en el rango de 0-255
    if qmax > 255
        qmax = 255;
    end
    if qmin < 0 
        qmin = 0;
    end
    
    nI = qmin + ((qmax-qmin) / (pmax-pmin)) * [I - pmin]; 
    
end

