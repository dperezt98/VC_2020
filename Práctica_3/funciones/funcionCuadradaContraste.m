function nI = funcionCuadradaContraste(I)
%FUNCIONCUADRADA Aplica la función cuadrada: q = p^2/255 . Para modificar
%el contraste de la imagen
    Id = double(I);
    nI = uint8(Id.^2/255);
end

