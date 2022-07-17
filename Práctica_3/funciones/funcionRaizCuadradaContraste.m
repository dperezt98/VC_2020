function nI = funcionRaizCuadradaContraste(I)
%FUNCIONRAIZCUADRADACONTRASTE Aplica la función cúbica: q = sqrt(255*p) . Para modificar
%el contraste de la imagen

    Id = double(I);
    nI = uint8(sqrt(255*Id));
end

